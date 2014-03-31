//
//  VTShell.m
//  vTeam
//
//  Created by zhang hailong on 13-4-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTShell.h"

#import <UIKit/UIKit.h>

#import <vTeam/IVTUIViewController.h>

#import <vTeam/NSURL+QueryValue.h>

#import "VTCreatorViewController.h"

#import "VTDOMParse.h"

#import <Security/Security.h>

#import <objc/runtime.h>


@interface VTServiceContainer : NSObject<IVTServiceContainer>{
    NSMutableSet * _taskTypes;
    Class _instanceClass;
}

-(id) initWithInstanceClass:(Class) instanceClass;

@end


@implementation VTServiceContainer

@synthesize instance = _instance;
@synthesize config = _config;
@synthesize context = _context;
@synthesize inherit = _inherit;

-(void) dealloc{
    [_instance release];
    [_config release];
    [_taskTypes release];
    [super dealloc];
}

-(id) initWithInstanceClass:(Class) instanceClass{
    if((self = [super init])){
        _instanceClass = instanceClass;
    }
    return self;
}

-(BOOL) hasTaskType:(Protocol *) taskType{
    if(_inherit){
        for(NSValue * v in _taskTypes){
            Protocol * protocol = (Protocol *)[v pointerValue];
            if(protocol == taskType || (_inherit && protocol_conformsToProtocol(taskType,protocol))){
                return YES;
            }
        }
    }
    else{
        NSValue * v = [NSValue valueWithPointer:taskType];
        return [_taskTypes containsObject:v];
    }
    return NO;
}

-(void) addTaskType:(Protocol *) taskType{
    if(_taskTypes == nil){
        _taskTypes = [[NSMutableSet alloc] initWithCapacity:4];
    }
    [_taskTypes addObject:[NSValue valueWithPointer:taskType]];
}

-(void) didReceiveMemoryWarning{
    [_instance didReceiveMemoryWarning];
}

-(id) instance{
    if(_instance == nil){
        _instance = [[_instanceClass alloc] init];
        [_instance setContext:_context];
        [_instance setConfig:_config];
    }
    return _instance;
}

@end


@interface VTShell(){
    NSMutableArray * _viewControllers;
    NSMutableArray * _serviceContainers;
    NSMutableDictionary * _focusValues;
    
}

@property(nonatomic,retain) id rootViewController;
@property(nonatomic,readonly) NSMutableArray * platformKeys;
@property(nonatomic,readonly) NSMutableDictionary * storyboards;
@property(nonatomic,copy) void (^ resultsCallback)(id resultsData,id sender);
@property(nonatomic,readonly) NSMutableDictionary * authValues;

@end

@implementation VTShell

@synthesize bundle = _bundle;
@synthesize config = _config;
@synthesize rootViewController = _rootViewController;
@synthesize styleSheet = _styleSheet;
@synthesize domStyleSheet = _domStyleSheet;
@synthesize platformKeys = _platformKeys;
@synthesize resultsCallback = _resultsCallback;
@synthesize authValues = _authValues;

-(void) dealloc{
    [_bundle release];
    [_config release];
    [_rootViewController release];
    [_viewControllers release];
    [_serviceContainers release];
    [_styleSheet release];
    [_focusValues release];
    [_domStyleSheet release];
    [_storyboards release];
    [_platformKeys release];
    [_authValues release];
    self.resultsCallback = nil;
    [super dealloc];
}

-(NSMutableArray *) platformKeys{
    
    if(_platformKeys == nil){
        
        _platformKeys = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIDevice * device = [UIDevice currentDevice];
        double systemVersion = [[device systemVersion] doubleValue];
        
        if([device respondsToSelector:@selector(userInterfaceIdiom)]){
            if([device userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                if(systemVersion >= 7.0){
                    [_platformKeys addObject:VTUIPlatform_iPad_iOS7];
                }
                [_platformKeys addObject:VTUIPlatform_iPad];
            }
            else{
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                if(screenSize.height == 568){
                    if(systemVersion >= 7.0){
                        [_platformKeys addObject:VTUIPlatform_iPhone5_iOS7];
                    }
                    [_platformKeys addObject:VTUIPlatform_iPhone5];
                }
                [_platformKeys addObject:VTUIPlatform_iPhone];
            }
        }
        
        if(systemVersion >= 7.0){
            [_platformKeys addObject:VTUIPlatform_iOS7];
        }
        
    }
    
    return _platformKeys;
}

-(id) initWithConfig:(id)config bundle:(NSBundle *) bundle{
    if((self = [super init])){
        _config = [config retain];
        _bundle = [bundle retain];
        
        NSArray * items = [config valueForKey:@"services"];
        
        if([items isKindOfClass:[NSArray class]]){
            
            for(id cfg in items){
                NSString * className = [cfg valueForKey:@"class"];
                if(className){
                    Class clazz = NSClassFromString(className);
                    if(clazz){
                        if([clazz conformsToProtocol:@protocol(IVTService)]){
                            
                            if([[cfg valueForKey:@"disabled"] boolValue]){
                                continue;
                            }
                            
                            id container = [self addService:clazz];
                            [container setContext:self];
                            [container setConfig:cfg];
                            [container setInherit:[[cfg valueForKey:@"inherit"] boolValue]];
                            NSArray * taskTypes = [cfg valueForKey:@"taskTypes"];
                            if([taskTypes isKindOfClass:[NSArray class]]){
                                for(NSString * taskType in taskTypes){
                                    Protocol * p  = NSProtocolFromString(taskType);
                                    if(p){
                                        [container addTaskType:p];
                                    }
                                    else{
                                        NSLog(@"Not found taskType %@",taskType);
                                    }
                                }
                            }
                            if([cfg booleanValueForKey:@"instance"]){
                                [container instance];
                            }
                        }
                        else{
                            NSLog(@"Service Class %@ not implement IVTService",className);
                        }
                    }
                    else{
                        NSLog(@"Not found Service Class %@",className);
                    }
                }
            }
            
        }
        
 
    }
    return self;
}

-(id<IVTServiceContainer>) addService:(Class) serviceClass{
    VTServiceContainer * container = [[[VTServiceContainer alloc] initWithInstanceClass:serviceClass] autorelease];
    if(_serviceContainers == nil){
        _serviceContainers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_serviceContainers addObject:container];
    return container;
}

-(id) getViewController:(NSURL *) url basePath:(NSString *) basePath{
    NSString * alias = [url firstPathComponent:basePath];
    id cfg = [[_config valueForKey:@"ui"] valueForKey:alias];
    if(cfg){
       
        BOOL cached = [[cfg valueForKey:@"cached"] boolValue];
        if(cached){
            for(id viewController in _viewControllers){
                if([[viewController alias] isEqualToString:alias] && [viewController isDisplaced]){
                    [viewController setBasePath:basePath];
                    [viewController setUrl:url];
                    return viewController;
                }
            }
        }
        
        id platform = nil;
        
        for(NSString * key in self.platformKeys){
            platform = [cfg valueForKey:key];
            if(platform){
                break;
            }
        }
        
        if(platform == nil){
            platform = cfg;
        }
        
        id viewController = nil;
        
        NSString * className = [platform valueForKey:@"class"];
        id storyboard = [platform valueForKey:@"storyboard"];
        
        if(className){
            Class clazz = NSClassFromString(className);
            if([clazz conformsToProtocol:@protocol(IVTUIViewController)]
               || [clazz isSubclassOfClass:[VTCreatorViewController class]]){
                
                
                
                NSString * view = [platform valueForKey:@"view"];
                
                if([clazz isSubclassOfClass:[UIViewController class]]){
                    viewController = [[[clazz alloc] initWithNibName:view bundle:_bundle] autorelease];
                }
                else{
                    viewController = [[[clazz alloc] init] autorelease];
                }
                
                if([viewController isKindOfClass:[VTCreatorViewController class]]){
                    [viewController view];
                    viewController = [(VTCreatorViewController *) viewController viewController];
                }
    
            }
        }
        else if(storyboard && NSClassFromString(@"UIStoryboard")){
            
            NSString * identifier = nil;
            NSString * name = nil;
            if([storyboard isKindOfClass:[NSDictionary class]]){
                identifier = [storyboard valueForKey:@"identifier"];
                name = [storyboard valueForKey:@"name"];
            }
            else{
                name = storyboard;
            }
            
            if(name){
                
                UIStoryboard * board = [self.storyboards valueForKey:name];
                
                if(board == nil){
                    board = [UIStoryboard storyboardWithName:name bundle:self.bundle];
                    [self.storyboards setValue:board forKey:name];
                }
                
                if(identifier){
                    viewController = [board instantiateViewControllerWithIdentifier:identifier];
                }
                else{
                    viewController = [board instantiateInitialViewController];
                }
                
                if(![viewController conformsToProtocol:@protocol(IVTUIViewController)]){
                    viewController = nil;
                }
            }
        }
        
        if(viewController){
            
            [viewController setContext:self];
            [viewController setAlias:alias];
            [viewController setBasePath:basePath];
            [viewController setScheme:[cfg valueForKey:@"scheme"]];
            [viewController setUrl:url];
            [viewController setConfig:cfg];
            
            if(cached){
                if(_viewControllers == nil){
                    _viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
                }
                [_viewControllers addObject:viewController];
            }
        }
        
        return viewController;
    }
    
    return nil;
}

-(void) didReceiveMemoryWarning{
    NSInteger c = [_viewControllers count];
    for(int i=0;i<c;i++){
        id viewController = [_viewControllers objectAtIndex:i];
        if([viewController isDisplaced]){
            [_viewControllers removeObjectAtIndex:i];
            i --;
            c --;
        }
    }
    
    for(id serviceContainer in _serviceContainers){
        [serviceContainer didReceiveMemoryWarning];
    }
    
    [_authValues release];
    _authValues = nil;
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    for(id container in _serviceContainers){
        if([container hasTaskType:taskType]){
            id s = [container instance];
            if([s handle:taskType task:task priority:priority]){
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    for(id container in _serviceContainers){
        if([container hasTaskType:taskType]){
            id s = [container instance];
            if([s cancelHandle:taskType task:task]){
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) cancelHandleForSource:(id) source{
    for(id container in _serviceContainers){
        id s = [container instance];
        if([s cancelHandleForSource:source]){
            return YES;
        }
    }
    return NO;
}

-(id) focusValueForKey:(NSString *) key{
    return [_focusValues objectForKey:key];
}

-(void) setFocusValue:(id) value forKey:(NSString *) key{
    if(_focusValues== nil){
        _focusValues = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    if(value){
        [_focusValues setObject:value forKey:key];
    }
    else{
        [_focusValues removeObjectForKey:key];
    }
}

-(id) rootViewController{
    if(_rootViewController == nil){
        NSString * url = [self.config valueForKey:@"url"];
        if(url){
            self.rootViewController = [self getViewController:[NSURL URLWithString:url] basePath:@"/"];
            [_rootViewController loadUrl:[NSURL URLWithString:url] basePath:@"/" animated:NO];
        }
    }
    return _rootViewController;
}

-(VTStyleController *) styleController{
    return [self.styleSheet styleController];
}

-(void) setStyleController:(VTStyleController *)styleController{
    [self.styleSheet setStyleController:styleController];
}

-(VTStyleSheet *) styleSheet{
    if(_styleSheet == nil){
        _styleSheet = [[VTStyleSheet alloc] init];
    }
    return _styleSheet;
}

-(VTDOMStyleSheet *) domStyleSheet{
    if(_domStyleSheet == nil){
        _domStyleSheet = [[VTDOMStyleSheet alloc] init];
    }
    return _domStyleSheet;
}

-(void) loadDOMStyleSheet:(NSString *) cssContent{
    VTDOMParse * parse = [[VTDOMParse alloc] init];
    [parse parseCSS:cssContent toStyleSheet:self.domStyleSheet];
    self.domStyleSheet.version ++;
    [parse release];
}

-(void) waitResultsData:(void (^)(id resultsData,id sender))callback{
    self.resultsCallback = callback;
}

-(void) setResultsData:(id)resultsData sender:(id)sender{
    if(_resultsCallback){
        _resultsCallback(resultsData,sender);
        self.resultsCallback = nil;
    }
}

-(void) setResultsData:(id)resultsData{
    [self setResultsData:resultsData sender:nil];
}

-(BOOL) hasWaitResultsData{
    return _resultsCallback != nil;
}

-(NSString *) domain{
    return [[NSBundle mainBundle] bundleIdentifier];
}

-(id) uid{
    return [self authValueForKey:@"uid"];
}

-(void) setUid:(id)uid{
    [self setAuthValue:uid forKey:@"uid"];
}

-(NSString *) token{
    return [self authValueForKey:@"token"];
}

-(void) setToken:(NSString *)token{
    [self setAuthValue:token forKey:@"token"];
}

-(NSMutableDictionary *) authValues{
    
    if(_authValues == nil){
        
        NSString * domain = [self domain];
        
        NSMutableDictionary * query = [NSMutableDictionary dictionaryWithObjectsAndKeys:(NSString *)kSecClassGenericPassword,(NSString *)kSecClass
                                , domain,(NSString *) kSecAttrAccount
                                , domain,(NSString *) kSecAttrService
                                , domain,(NSString *) kSecAttrLabel
                                , [NSNumber numberWithBool:YES],(NSString *) kSecReturnData
                                , nil];
        
        NSData * data = nil;
        
        OSStatus status = SecItemCopyMatching((CFDictionaryRef)query,(CFTypeRef *) & data);
        
        [data autorelease];
        
        if(status != noErr){
            SecItemDelete((CFDictionaryRef) query);
            data = nil;
        }
        
        if(data == nil){
            
            _authValues = [[NSMutableDictionary alloc] initWithCapacity:4];
            
            data = [NSMutableData dataWithCapacity:128];
            
            NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:(NSMutableData *)data];
            
            [_authValues encodeWithCoder:archiver];
            
            [archiver finishEncoding];
            [archiver release];
            
            [query removeObjectForKey:(NSString *)kSecReturnData];
            [query setValue:data forKey:(NSString *)kSecValueData];
            
            SecItemAdd( (CFDictionaryRef) query, nil);
        }
        else{

            NSKeyedUnarchiver * archiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            
            _authValues = [[NSMutableDictionary alloc] initWithCoder:archiver];
            
            [archiver finishDecoding];
            [archiver release];
        }
    }
    
    if(_authValues == nil){
        _authValues = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    return _authValues;
}

-(void) setAuthValue:(id) value forKey:(NSString *)key{
    
    if(value){
        [self.authValues setValue:value forKey:key];
    }
    else{
        [self.authValues removeObjectForKey:key];
    }
    
    NSMutableData * data = [NSMutableData dataWithCapacity:128];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [self.authValues encodeWithCoder:archiver];
    
    [archiver finishEncoding];
    
    [archiver release];
    
    NSString * domain = [self domain];
    
    NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:(NSString *)kSecClassGenericPassword,(NSString *)kSecClass
                          , domain,(NSString *) kSecAttrAccount
                          , domain,(NSString *) kSecAttrService
                          , domain,(NSString *) kSecAttrLabel
                          , nil];
    
    SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject:data forKey:(NSString *)kSecValueData]);
    
}

-(id) authValueForKey:(NSString *) key{
    return [[self authValues] valueForKey:key];
}

@end
