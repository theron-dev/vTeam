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
    
    if(_contentViewController){
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
        
        NSString * alias = [url lastPathComponent];
        
        if(![[_contentViewController alias] isEqualToString:alias]){
            id viewController = [self.context getViewController:url basePath:@"/"];
            [self setContentViewController:viewController];
        }
        
        if([self.contentViewController respondsToSelector:@selector(receiveUrl:source:)]){
            [(id)self.contentViewController receiveUrl:url source:self];
        }
        
        return YES;
    }
    else{
        return [super openUrl:url animated:animated];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self contentViewController] viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self contentViewController] viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self contentViewController] viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[self contentViewController] viewDidDisappear:animated];
}

-(void) receiveUrl:(NSURL *)url source:(id)source{
    
    NSString * schema = [url scheme];
    
    if([schema isEqualToString:@"fold"]){
        NSArray * paths = [url pathComponents:@"/"];
        if([paths count] > 1){
            NSString * alias = [paths objectAtIndex:1];
            if(![[self.contentViewController alias] isEqualToString:alias]){
                id viewController = [self.context getViewController:url basePath:[NSString stringWithFormat:@"/%@",[paths objectAtIndex:0]]];
                [self setContentViewController:viewController];
            }
        }
    }
    
    if([self.contentViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.contentViewController receiveUrl:url source:source];
    }
}

-(void) setConfig:(id)config{
    [super setConfig:config];
    
    id v = [config valueForKey:@"scheme"];
    
    if(v){
        self.scheme = v;
    }
}
@end
