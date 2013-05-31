//
//  VTNavigationController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTNavigationController.h"

#import "NSURL+QueryValue.h"

@interface VTNavigationController ()

@end

@implementation VTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@synthesize context = _context;
@synthesize parentController = _parentController;
@synthesize config = _config;
@synthesize alias = _alias;
@synthesize url = _url;
@synthesize styleContainer = _styleContainer;
@synthesize dataOutletContainer = _dataOutletContainer;
@synthesize basePath = _basePath;
@synthesize layoutContainer = _layoutContainer;

-(BOOL) isDisplaced{
    return _parentController == nil && ( ![self isViewLoaded] || self.view.superview == nil);
}

-(void) dealloc{
    [_config release];
    [_alias release];
    [_url release];
    [_basePath release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [_layoutContainer release];
    [super dealloc];
}

-(void) setPaths:(NSArray * ) paths animated:(BOOL) animated{
    
    NSMutableArray * newViewControllers= [ NSMutableArray arrayWithCapacity:4];
    
    NSInteger index = 0;
    NSArray * viewControllers = [self viewControllers];
    NSString * basePath = [_basePath stringByAppendingPathComponent:_alias];
    
    while(index < [paths count] && index < [viewControllers count]){
        
        NSString * alias = [paths objectAtIndex:index];
        
        id viewController = [viewControllers objectAtIndex:index];
        
        if([[viewController alias] isEqualToString:alias]){
            basePath = [basePath stringByAppendingPathComponent:alias];
            [newViewControllers addObject:viewController];
        }
        else{
            break;
        }
        
        index ++;
    }
    
    NSInteger i = index;
    
    while (i < [viewControllers count]) {
        id viewController = [viewControllers objectAtIndex:i];
        [viewController setParentController:nil];
        i++;
    }
    
    while(index < [paths count]){
        
        NSString * alias = [paths objectAtIndex:index];
        
        id viewController = [self.context getViewController:_url basePath:basePath];
        
        if(viewController){
            [viewController setParentController:self];
            [newViewControllers addObject:viewController];
        }
        
        basePath = [basePath stringByAppendingPathComponent:alias];
        
        index ++;
    }
    
    [self setViewControllers:newViewControllers animated:animated];
}

-(void) reloadURL{
    NSString * path = [_url firstPathComponent:[_basePath stringByAppendingPathComponent:_alias]];
    [self setPaths:[NSArray arrayWithObject:path] animated:NO];
}

-(BOOL) canOpenUrl:(NSURL *) url{
    if([[url scheme] isEqualToString:@"nav"]){
        return YES;
    }
    return [_parentController canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
    
    if([[url scheme] isEqualToString:@"nav"]){

        NSLog(@"%@",[url absoluteString]);
        
        NSString * basePath = [_basePath stringByAppendingPathComponent:_alias];

        if([[url path] hasPrefix:basePath]){
            
            NSArray * paths = [url pathComponents:basePath];
            
            if([paths count] >0){
            
                self.url = url;
                
                [self setPaths:[_url pathComponents:[_basePath stringByAppendingPathComponent:_alias]] animated:animated];
                
                if([self.topViewController respondsToSelector:@selector(receiveUrl:source:)]){
                    [(id)self.topViewController receiveUrl:url source:self];
                }
                
                return YES;
            }
        }
    }
    return [_parentController openUrl:url animated:animated];
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [[self topViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate{
    return [[self topViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [[self topViewController] supportedInterfaceOrientations];
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [[self topViewController] preferredInterfaceOrientationForPresentation];
}

-(void) setConfig:(id)config{
    if(_config != config){
        [_config release];
        _config = [config retain];
        
        id v = [config valueForKey:@"navbar-hidden"];
        
        if(v){
            [self setNavigationBarHidden:[v boolValue] animated:NO];
        }
        
        v = [config valueForKey:@"toolbar-hidden"];
        
        if(v){
            [self setToolbarHidden:[v boolValue] animated:NO];
        }
        
    }
}

-(void) receiveUrl:(NSURL *) url source:(id) source{
    if([self.topViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.topViewController receiveUrl:url source:source];
    }
}

@end
