//
//  VTViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTViewController.h"

#import "IVTAction.h"

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
    [_styleContainer setStyleSheet:[self.context styleSheet]];
    [_layoutContainer layout];
    
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

-(BOOL) canOpenUrl:(NSURL *) url{
    return [_parentController canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
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

-(void) reloadURL{
    
}

-(void) receiveUrl:(NSURL *) url source:(id) source{
    
}

-(IBAction) doAction:(id)sender{
    if([sender conformsToProtocol:@protocol(IVTAction)]){
        NSString * actionName = [sender actionName];
        id userInfo = [sender userInfo];
        if([actionName isEqualToString:@"url"]){
            if(userInfo){
                [self openUrl:[NSURL URLWithString:userInfo relativeToURL:self.url] animated:YES];
            }
        }
        else if([actionName isEqualToString:@"openUrl"]){
            if(userInfo){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:userInfo]];
            }
        }
    }
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_layoutContainer layout];
}

@end
