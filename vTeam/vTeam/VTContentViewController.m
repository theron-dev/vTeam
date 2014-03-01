//
//  VTContentViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTContentViewController.h"

#import "NSURL+QueryValue.h"

@interface VTContentViewController ()

@property(nonatomic,retain) UIViewController<IVTUIViewController> * contentViewController;

@end

@implementation VTContentViewController

@synthesize contentView = _contentView;
@synthesize contentViewController = _contentViewController;

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

-(void) viewDidUnload{
    [super viewDidUnload];
    [self setContentView:nil];
    if([_contentViewController isViewLoaded]){
        [[_contentViewController view] removeFromSuperview];
    }
}

-(void) dealloc{
    [_contentView release];
    [_contentViewController setParentController:nil];
    [_contentViewController release];
    [super dealloc];
}

-(void) setContentViewController:(UIViewController<IVTUIViewController> *)contentViewController{
    if(_contentViewController != contentViewController){
        if([_contentViewController isViewLoaded]){
            [[_contentViewController view] removeFromSuperview];
        }
        [_contentViewController setParentController:nil];
        [_contentViewController release];
        _contentViewController = [contentViewController retain];
        [_contentViewController setParentController:self];
        
        if(_contentViewController){
            if([self isViewLoaded]){
                if(self.view.window){
                    UIView * contentView = [self contentView];
                    if(contentView == nil){
                        contentView = self.view;
                    }
                    UIView * v = [_contentViewController view];
                    [v setFrame:contentView.bounds];
                    [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                    [contentView addSubview:v];
                }
            }
        }
    }
}

-(void) reloadURL{
    NSString * basePath = [self.basePath stringByAppendingPathComponent:self.alias];
    NSString * alias = [self.url firstPathComponent:basePath];
    if(![[_contentViewController alias] isEqualToString:alias]){
        id viewController = [self.context getViewController:self.url basePath:basePath];
        [self setContentViewController:viewController];
    }
}

-(BOOL) canOpenUrl:(NSURL *)url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"content";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        return YES;
    }
    
    return [super canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *)url animated:(BOOL)animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"content";
    }
    
    if([url.scheme isEqualToString:scheme]){
    
        [self loadUrl:url basePath:self.basePath animated:animated];
        
        return YES;
    }
    else{
        return [super openUrl:url animated:animated];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_contentViewController){
        
        UIView * contentView = [self contentView];
        if(contentView == nil){
            contentView = self.view;
        }
        
        UIView * v = [_contentViewController view];
        
        if(v.superview == nil){
            [v setFrame:contentView.bounds];
            [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [contentView addSubview:v];
        }
    }
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    

}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(NSString *) loadUrl:(NSURL *)url basePath:(NSString *)basePath animated:(BOOL)animated{
    
    basePath = [basePath stringByAppendingPathComponent:self.alias];
    
    NSString * alias = [url firstPathComponent:basePath];
    
    if(alias){
        if(![alias isEqualToString:[self.contentViewController alias]]){
            id viewController = [self.context getViewController:url basePath:basePath];
            [self setContentViewController:viewController];
        }
        if(self.contentViewController){
            basePath = [self.contentViewController loadUrl:url basePath:basePath animated:animated];
        }
    }
    
    return basePath;
}

-(void) setConfig:(id)config{
    [super setConfig:config];
    
    id v = [config valueForKey:@"scheme"];
    
    if(v){
        self.scheme = v;
    }
}

-(id) topController{
    return [[self contentViewController] topController];
}

@end
