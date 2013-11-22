//
//  VTViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTViewController.h"

#import "IVTAction.h"

#import "VTPopWindow.h"
#import "NSURL+QueryValue.h"

@interface VTViewController ()

@end

@implementation VTViewController

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
    
    [_styleContainer setStyleSheet:[self.context styleSheet]];
    [_layoutContainer layout];
    [_dataOutletContainer applyDataOutlet:self];

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

-(BOOL) canOpenUrl:(NSURL *) url{
    return [_parentController canOpenUrl:url];
}


-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
    
    NSString * schema = [url scheme];
    
    if([schema isEqualToString:@"pop"]){

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
    else if([schema isEqualToString:@"present"]){
        
        NSString * alias = [url firstPathComponent:@"/"];
    
        if([alias length]){

            if([url.host length]){
                
                if([url.host isEqualToString:self.scheme]){
                    
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
    if([self.config valueForKey:@"orientations"]){
        NSArray * orientations = [self.config valueForKey:@"orientations"];
        for(NSNumber * orientation in orientations){
            if([orientation intValue] == toInterfaceOrientation){
                return YES;
            }
        }
        return NO;
    }
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    NSUInteger rs = 0;
    
    if([self.config valueForKey:@"orientations"]){
        NSArray * orientations = [self.config valueForKey:@"orientations"];
        for(NSNumber * orientation in orientations){
            int i = [orientation intValue];
            if(i == UIInterfaceOrientationPortrait){
                rs = rs | UIInterfaceOrientationMaskPortrait;
            }
            else if(i == UIInterfaceOrientationPortraitUpsideDown){
                rs = rs | UIInterfaceOrientationMaskPortraitUpsideDown;
            }
            else if(i == UIInterfaceOrientationLandscapeLeft){
                rs = rs | UIInterfaceOrientationMaskLandscapeLeft;
            }
            else if(i == UIInterfaceOrientationLandscapeRight){
                rs = rs | UIInterfaceOrientationMaskLandscapeRight;
            }
        }
        
    }
    
    if(rs == 0){
        return UIInterfaceOrientationMaskPortrait;
    }
    return rs;
}


-(NSString *) loadUrl:(NSURL *) url basePath:(NSString *) basePath animated:(BOOL) animated{
    return [basePath stringByAppendingPathComponent:self.alias];
}

-(IBAction) doAction:(id)sender{
    if([sender conformsToProtocol:@protocol(IVTAction)]){
        NSString * actionName = [sender actionName];
        id userInfo = [sender userInfo];
        if([actionName isEqualToString:@"url"]){
            if(userInfo){
                [self openUrl:[NSURL URLWithString:
                               [userInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                     relativeToURL:self.url] animated:YES];
            }
        }
        else if([actionName isEqualToString:@"openUrl"]){
            if(userInfo){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:userInfo]];
            }
        }
        else if([actionName isEqualToString:@"popclose"]){
            [[VTPopWindow topPopWindow] closeAnimated:YES];
        }
        else if([actionName isEqualToString:@"popclosed"]){
            [[VTPopWindow topPopWindow] closeAnimated:NO];
        }
    }
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_layoutContainer layout];
}

-(void) setConfig:(id)config{
    if(_config != config){
        [config retain];
        [_config release];
        _config = config;
        
        NSString * title = [config valueForKey:@"title"];
        
        if(title){
            self.title = title;
        }
        
        id hidesBottomBarWhenPushed = [config valueForKey:@"hidesBottomBarWhenPushed"];
        
        if(hidesBottomBarWhenPushed){
            self.hidesBottomBarWhenPushed = [hidesBottomBarWhenPushed boolValue];
        }
    }
}

-(id) topController{
    return self;
}

@end
