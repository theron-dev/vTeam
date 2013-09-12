//
//  VTTabBarController.m
//  vTeam
//
//  Created by zhang hailong on 13-7-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabBarController.h"

#import "NSURL+QueryValue.h"

@interface VTTabBarController ()

@end

@implementation VTTabBarController

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
    
#ifdef __IPHONE_7_0
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
        
        UIRectEdge edge = UIRectEdgeNone;
        
        NSString * cfg = [self.config valueForKey:@"edgesForExtendedLayout"];
        
        if(cfg){
            
            if([cfg isEqualToString:@"all"]){
                edge |= UIRectEdgeAll;
            }
            
            if([cfg rangeOfString:@"left"].location != NSNotFound){
                edge |= UIRectEdgeLeft;
            }
            
            if([cfg rangeOfString:@"right"].location != NSNotFound){
                edge |= UIRectEdgeRight;
            }
            
            if([cfg rangeOfString:@"top"].location != NSNotFound){
                edge |= UIRectEdgeTop;
            }
            
            if([cfg rangeOfString:@"bottom"].location != NSNotFound){
                edge |= UIRectEdgeBottom;
            }
            
            [self setEdgesForExtendedLayout:edge];
        }
    }
    
#endif
    
    for(id controller in _controllers){
        if([controller respondsToSelector:@selector(setContext:)]){
            [controller setContext:self.context];
        }
        if([controller respondsToSelector:@selector(setParentController:)]){
            [controller setParentController:self];
        }
    }
    
}

-(void) viewDidUnload{
    for(id controller in _controllers){
        if([controller respondsToSelector:@selector(setDelegate:)]){
            [controller setDelegate:nil];
        }
        if([controller respondsToSelector:@selector(setContext:)]){
            [controller setContext:nil];
        }
        if([controller respondsToSelector:@selector(setParentController:)]){
            [controller setParentController:nil];
        }
    }
    [super viewDidUnload];
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
@synthesize scheme = _scheme;
@synthesize controllers = _controllers;

-(BOOL) isDisplaced{
    return _parentController == nil && ( ![self isViewLoaded] || self.view.superview == nil);
}

-(void) dealloc{
    for(id controller in _controllers){
        [controller setDelegate:nil];
        [controller setContext:nil];
    }
    [_controllers release];
    [_config release];
    [_alias release];
    [_url release];
    [_basePath release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [_layoutContainer release];
    [_scheme release];
    [super dealloc];
}


-(void) setConfig:(id)config{
    if(_config != config){
        [_config release];
        _config = [config retain];
        
        id v = [config valueForKey:@"scheme"];
        
        if(v){
            self.scheme = v;
        }
        
        NSArray * items = [config valueForKeyPath:@"items"];
        
        NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:4];
        
        for (id item in items) {
            if([item valueForKey:@"url"]){
                id viewController = [self.context getViewController:[NSURL URLWithString:[item valueForKey:@"url"]] basePath:@"/"];
                if(viewController){
                    if([item valueForKey:@"title"]){
                        [[viewController tabBarItem] setTitle:[item valueForKey:@"title"]];
                    }
                    if([item valueForKey:@"image"]){
                        [[viewController tabBarItem] setImage:[UIImage imageNamed:[item valueForKey:@"image"]]];
                    }
                    [viewController setParentController:self];
                    [viewController loadUrl:[NSURL URLWithString:[item valueForKey:@"url"]] basePath:@"/" animated:NO];
                    [viewControllers addObject:viewController];
                }
                
            }
        }
        
        [self setViewControllers:viewControllers];
    }
}

-(NSString *) loadUrl:(NSURL *)url basePath:(NSString *)basePath animated:(BOOL)animated{
    return [basePath stringByAppendingPathComponent:self.alias];
}

-(BOOL) canOpenUrl:(NSURL *)url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"tab";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        return YES;
    }
    
    return NO;
}

-(BOOL) openUrl:(NSURL *)url animated:(BOOL)animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"tab";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        NSString * path = [url firstPathComponent:@"/"];
        
        id viewController = nil;
        
        for(viewController in self.viewControllers){
            if([[viewController alias] isEqualToString:path]){
                break;
            }
        }
        
        if(viewController){
            if(self.selectedViewController != viewController){
                [self setSelectedViewController:viewController];
            }
        }
        
        [(id)self.selectedViewController loadUrl:url basePath:@"/" animated:animated];

        return YES;
    }
    else if([[url scheme] isEqualToString:@"present"]){
        
        NSString * alias = [url firstPathComponent:@"/"];
        
        if([alias length]){
        
            if([url.host length]){
                
                if([url.host isEqualToString:scheme]){
                    
                    id modalViewController = self;
                    
                    while([modalViewController modalViewController]){
                        modalViewController = [modalViewController modalViewController];
                    }
                    
                    NSLog(@"%@",[url absoluteString]);
                    
                    id viewController = [self.context getViewController:url basePath:@"/"];
                    
                    if(viewController){
                        
                        [viewController setParentController:modalViewController];
                        
                        [modalViewController presentModalViewController:viewController animated:animated];
                        
                        return YES;
                    }
                    
                }
                
            }
            else{
                
                NSLog(@"%@",[url absoluteString]);
                
                id viewController = [self.context getViewController:url basePath:@"/"];
                
                if(viewController){
                    
                    [viewController setParentController:self];
                    
                    [self presentModalViewController:viewController animated:animated];
                    
                    return YES;
                }
            }
        }
        else if([self.url.scheme isEqualToString:@"present"]){
            
            NSLog(@"%@",[url absoluteString]);
            
            [self dismissModalViewControllerAnimated:animated];
            
            return YES;
        }
    }
    
    return NO;
}



-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [[self selectedViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate{
    return [[self selectedViewController] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [[self selectedViewController] supportedInterfaceOrientations];
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [[self selectedViewController] preferredInterfaceOrientationForPresentation];
}


-(void) receiveUrl:(NSURL *) url source:(id) source{
    if([self.selectedViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.selectedViewController receiveUrl:url source:source];
    }
}

@end
