//
//  VTNavigationController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTNavigationController.h"

#import "NSURL+QueryValue.h"
#import "VTNavigationBar.h"
#import "VTPopWindow.h"

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

-(NSString *) loadUrl:(NSURL *) url basePath:(NSString *) basePath animated:(BOOL) animated{
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    NSMutableArray * newViewControllers = [NSMutableArray arrayWithCapacity:4];
    
    basePath = [basePath stringByAppendingPathComponent:self.alias];
    
    NSString * alias = [url firstPathComponent:basePath];
    
    while(alias){
        
        
        if([viewControllers count] >0){
            
            id viewController = [viewControllers objectAtIndex:0];
            
            if([alias isEqualToString:[viewController alias]]){
                basePath = [viewController loadUrl:url basePath:basePath animated:animated];
                [newViewControllers addObject:viewController];
                [viewControllers removeObjectAtIndex:0];
            }
            else{
                for(viewController in viewControllers){
                    [viewController setParentController:nil];
                }
                [viewControllers removeAllObjects];
            }
        }
        else{
            id viewController = [self.context getViewController:url basePath:basePath];
            if(viewController){
                [viewController setParentController:self];
                basePath = [viewController loadUrl:url basePath:basePath animated:animated];
                [newViewControllers addObject:viewController];
            }
            else{
                break;
            }
        }
        
        alias = [url firstPathComponent:basePath];
    }
    
    for(id viewController in viewControllers){
        [viewController setParentController:nil];
    }
    
    [viewControllers removeAllObjects];
    
    [self setViewControllers:newViewControllers animated:animated];
    
    return basePath;
}


-(BOOL) canOpenUrl:(NSURL *) url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"nav";
    }
    
    if([[url scheme] isEqualToString:scheme]){
        return YES;
    }
    return [_parentController canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"nav";
    }
    
    if([[url scheme] isEqualToString:scheme]){

        NSLog(@"%@",[url absoluteString]);
         
        [self loadUrl:url basePath:_basePath animated:animated];
        
        return YES;

    }
    else if([[url scheme] isEqualToString:@"pop"]){
        
        NSLog(@"%@",[url absoluteString]);
        
        id viewController = [self.context getViewController:url basePath:@"/"];
        
        if(viewController){
            
            VTPopWindow * win = [VTPopWindow popWindow];
            
            win.backgroundColor = [UIColor clearColor];
            
            [win showAnimated:animated];
            
            win.rootViewController = viewController;
            
            [viewController setParentController:self];
            
            return YES;
        }
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
        
        NSString * title = [config valueForKey:@"title"];
        
        if(title){
            self.title = title;
        }
        
        v = [config valueForKey:@"navbar-bg"];
        
        if(v){
            if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:)]){
                [(VTNavigationBar *)self.navigationBar setBackgroundImage:[UIImage imageNamed:v]];
            }
        }

    }
}


@end
