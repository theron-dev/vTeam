//
//  VTTabViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-7-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabViewController.h"

@interface VTTabViewController ()

@end

@implementation VTTabViewController

@synthesize contentView = _contentView;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;

-(UIViewController *) selectedViewController{
    if([_viewControllers count] == 0){
        return nil;
    }
    if(_selectedIndex >= [_viewControllers count]){
        _selectedIndex = 0;
    }
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(UIButton *) selectedTabButton{
    if(_selectedIndex < [_tabButtons count]){
        return [_tabButtons objectAtIndex:_selectedIndex];
    }
    return nil;
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    
    if([_viewControllers count] == 0){
        return;
    }
    
    if(selectedIndex >= [_viewControllers count]){
        selectedIndex = 0;
    }
    
    
    if([self isViewLoaded]){
        UIViewController * viewController = [self selectedViewController];
        if([viewController isViewLoaded]){
            
            if(_selectedIndex == selectedIndex){
                return;
            }
            
            if(viewController.view.superview){
                if(viewController.view.window){
                    [viewController.view removeFromSuperview];
                }
                else{
                    [viewController viewWillDisappear:NO];
                    [[viewController view] removeFromSuperview];
                    [viewController viewDidDisappear:NO];
                }
            }
        }
    }
    
    _selectedIndex = selectedIndex;

    if([self isViewLoaded]){
        
        UIViewController * viewController = [self selectedViewController];
        
        [viewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight];
        [viewController.view setFrame:self.contentView.bounds];
        
        if(self.view.window){
            [self.contentView addSubview:viewController.view];
        }
        else{
            [viewController viewWillAppear:NO];
            [self.contentView addSubview:viewController.view];
            [viewController viewDidAppear:NO];
        }
        
    }
    
    NSInteger index = 0;
    
    for(UIButton * button in _tabButtons){
        
        [button setSelected:index == _selectedIndex];
        
        index ++;
    }
    
}

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
    
    UIViewController * viewController = [self selectedViewController];
    
    [viewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [viewController.view setFrame:self.contentView.bounds];
    
    if(self.view.window){
        [self.contentView addSubview:viewController.view];
    }
    else{
        [viewController viewWillAppear:NO];
        [self.contentView addSubview:viewController.view];
        [viewController viewDidAppear:NO];
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
    
    UIViewController * viewController = [self selectedViewController];
    if([viewController isViewLoaded]){
        [self.contentView addSubview:viewController.view];
    }
    
}

-(void) dealloc{
    [_contentView release];
    for(id viewController in _viewControllers){
        [viewController setParentController:nil];
    }
    [_viewControllers release];
    [super dealloc];
}


-(void) reloadURL{

}

-(BOOL) canOpenUrl:(NSURL *)url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"tab";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        return YES;
    }
    
    return [super canOpenUrl:url];
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
                [self setSelectedIndex:[_viewControllers indexOfObject:viewController]];
            }
        }
        
        return YES;
    }
    else{
        return [super openUrl:url animated:animated];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self selectedViewController] viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self selectedViewController] viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self selectedViewController] viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[self selectedViewController] viewDidDisappear:animated];
}

-(void) receiveUrl:(NSURL *)url source:(id)source{
    
    if([self.selectedViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.selectedViewController receiveUrl:url source:source];
    }
}

-(void) setConfig:(id)config{
    [super setConfig:config];
    
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
                [viewController setParentController:self];
                [viewControllers addObject:viewController];
            }
            
        }
    }
    
    [self setViewControllers:viewControllers];
}

-(IBAction) doTabAction:(id) sender{
    if(sender == [self selectedTabButton]) {
        if([self.selectedViewController isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
        }
    }
    else{
        [self setSelectedIndex:[_tabButtons indexOfObject:sender]];
    }
}

@end
