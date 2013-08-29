//
//  VTHeapViewController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHeapViewController.h"

#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION  0.3
#define ANIMATION_SCALE     0.98
#define ANIMATION_ALPHA     0.8

typedef enum {
    VTHeapViewControllerPanDirectionNone,VTHeapViewControllerPanDirectionLeft,VTHeapViewControllerPanDirectionRight
}VTHeapViewControllerPanDirection;

@interface VTHeapViewController (){
    NSMutableArray * _viewControllers;
    UIPanGestureRecognizer * _panGestureRecognizer;
    BOOL _panBeginTouch;
    CGPoint _panBeginLocation;
    CGPoint _panPrevLocation;
    VTHeapViewControllerPanDirection _direction;
}

-(void) setViewControllers:(NSArray *) viewControllers animated:(BOOL)animated;

@end

@implementation VTHeapViewController

@synthesize animating = _animating;

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
    
    UIView * topView = [[self topViewController] view];
    
    if(topView){
        
        if(topView.superview == nil){
            [topView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.view addSubview:topView];
        }
        
        [self.view bringSubviewToFront:topView];
        
        CGSize size = self.view.bounds.size;
        
        [topView setFrame:CGRectMake(0, 0, size.width, size.height)];
        [topView setUserInteractionEnabled:YES];
        
    }
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [_panGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
}

-(void) panGestureRecognizerAction:(UIPanGestureRecognizer * ) gestureRecognizer{
    
    UIGestureRecognizerState state = gestureRecognizer.state;
    
    if(_animating){
        return;
    }
    
    if(state == UIGestureRecognizerStateBegan){
        if(!_panBeginTouch){
            _panBeginTouch = YES;
            _panBeginLocation = [gestureRecognizer locationInView:self.view];
            _panPrevLocation = _panBeginLocation;
            _direction = VTHeapViewControllerPanDirectionNone;
            
            [gestureRecognizer setTranslation:_panBeginLocation inView:self.view];
        }
    }
    else if(state == UIGestureRecognizerStateChanged){
        if(_panBeginTouch){
            
            CGPoint p = [gestureRecognizer translationInView:self.view];
            CGFloat d = p.x - _panPrevLocation.x;
            _panPrevLocation = p;
            if(d >0 ){
                _direction = VTHeapViewControllerPanDirectionRight;
            }
            else if(d < 0){
                _direction = VTHeapViewControllerPanDirectionLeft;
            }
            
            d = p.x - _panBeginLocation.x;
            
            UIView * view = self.view;
            CGSize size = view.bounds.size;
            
            if(d > 0){
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    
                    UIView * v = [viewController view];
                    
                    [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                    [v setFrame:CGRectMake(0, 0, size.width, size.height)];
                    
                    if(v.superview != view){
                        [viewController viewWillAppear:NO];
                        [view insertSubview:v atIndex:0];
                        [viewController viewDidAppear:NO];
                    }
                    
                    CGFloat r = d / size.width;
                    
                    CGFloat scale = ANIMATION_SCALE + (1.0 - ANIMATION_SCALE) * r;
                    CGFloat alpha = ANIMATION_ALPHA + (1.0 - ANIMATION_ALPHA) * r;
                    
                    if(scale > 1.0){
                        scale = 1.0;
                    }
                    
                    if(alpha > 1.0){
                        alpha = 1.0;
                    }
                    
                    if(v.layer.mask == nil){
                        CALayer * mask = [[CALayer alloc] init];
                        mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
                        mask.frame = v.layer.bounds;
                        v.layer.mask = mask;
                        [mask release];
                    }
                    else{
                        v.layer.mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
                    }
                    
                    v.layer.transform = CATransform3DMakeScale(scale, scale, scale);
                    
                    v = [self.topViewController view];
                    
                    v.layer.mask = nil;
                    v.layer.transform = CATransform3DIdentity;
                    
                    [v setFrame:CGRectMake( d, 0, size.width, size.height)];
                }
                else{
                    
                    UIView * v = [self.topViewController view];
                    
                    v.layer.mask = nil;
                    v.layer.transform = CATransform3DIdentity;
                    [v setFrame:CGRectMake( 0, 0, size.width, size.height)];

                }
                
                
            }
            else if(d < 0){
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    if([viewController isViewLoaded]){
                        
                        UIView * v = [viewController view];
                        
                        if(v.superview ){
                            [viewController viewWillDisappear:NO];
                            [v removeFromSuperview];
                            [viewController viewDidDisappear:NO];
                        }
                    }
                }
                
                UIView * v = [self.topViewController view];
                [v setFrame:CGRectMake(0, 0, size.width, size.height)];
            }
            
        }
    }
    else if(state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateFailed){
        if(_panBeginTouch){
            _panBeginTouch = NO;
            
            CGPoint p = [gestureRecognizer translationInView:self.view];
            
            CGFloat d = p.x - _panBeginLocation.x;
            
            UIView * view = self.view;
            CGSize size = view.bounds.size;
            
            if(d >0 && _direction == VTHeapViewControllerPanDirectionRight){
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    if([viewController isViewLoaded]){
                        UIView * v = [viewController view];
                        [v setFrame:CGRectMake(0, 0, size.width, size.height)];
                    }
                }

                [self popViewController:YES];
            }
            else if(d <0 && _direction == VTHeapViewControllerPanDirectionLeft){
                
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    if([viewController isViewLoaded]){
                        UIView * v = [viewController view];
                        [viewController viewWillDisappear:NO];
                        [v removeFromSuperview];
                        [viewController viewDidDisappear:NO];
                    }
                }
                
            }
            else{
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    if([viewController isViewLoaded]){
                        UIView * v = [viewController view];
                        if(v.superview ){
                            [viewController viewWillDisappear:NO];
                            [v removeFromSuperview];
                            [viewController viewDidDisappear:NO];
                        }
                    }
                }
                
               
                UIView * v = [self.topViewController view];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:ANIMATION_DURATION];
                
                v.layer.mask = nil;
                v.layer.transform = CATransform3DIdentity;
                [v setFrame:CGRectMake(0, 0, size.width, size.height)];
                
                [UIView commitAnimations];
            }
            
        }
    }
    
}

-(void) viewDidUnload{
    [_panGestureRecognizer release],_panGestureRecognizer = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_viewControllers release];
    [_panGestureRecognizer release];
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self topViewController] viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[self topViewController] viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[self topViewController] viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[self topViewController] viewDidDisappear:animated];
}

-(UIImage *) titleImage{
    UIImageView * imageView = (UIImageView *)[self.navigationItem titleView];
    if([imageView isKindOfClass:[UIImageView class]]){
        return [imageView image];
    }
    return nil;
}

-(void) setTitleImage:(UIImage *)titleImage{
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:titleImage] autorelease];
}

-(UIViewController *) topViewController{
    return [_viewControllers lastObject];
}

-(void) popViewControllerAnimationTopDidStopAction:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIViewController * viewController = (UIViewController *) context;
    
    [viewController viewWillDisappear:YES];
    
    UIView * v = [viewController view];
    
    [v removeFromSuperview];
    
    [viewController viewDidDisappear:YES];
 
    [_viewControllers removeLastObject];
}

-(void) popViewControllerAnimationDidStopAction:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIViewController * viewController = (UIViewController *) context;
    
    UIView * v = [viewController view];
    
    [v setTransform:CGAffineTransformIdentity];
  
    _animating = NO;
}

-(void) popViewController:(BOOL) animated{
    
    if(_animating){
        return;
    }
    
    if([_viewControllers count] >1){
        
        UIViewController * topViewController = [_viewControllers lastObject];
        
        if(animated && [self isViewLoaded]){
         
            _animating = YES;
            
            UIView * view = self.view;
            CGSize size = view.bounds.size;
            
            UIView * v = [topViewController view];
            [UIView beginAnimations:nil context:topViewController];
            [UIView setAnimationDuration:ANIMATION_DURATION];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popViewControllerAnimationTopDidStopAction:finished:context:)];
            
            v.layer.mask = nil;
            v.layer.transform = CATransform3DIdentity;
            
            [v setFrame:CGRectMake(size.width, 0, size.width, size.height)];
            
            [UIView commitAnimations];
            
            topViewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
            
            v = [topViewController view];
            
            if(v.superview != view){
                
                [topViewController viewWillAppear:animated];
                
                [v setFrame:CGRectMake(0, 0, size.width, size.height)];
                
                if(v.layer.mask == nil){
                    CALayer * mask = [[CALayer alloc] init];
                    mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:ANIMATION_ALPHA].CGColor;
                    mask.frame = v.layer.bounds;
                    v.layer.mask = mask;
                    [mask release];
                }
                else{
                    v.layer.mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:ANIMATION_ALPHA].CGColor;
                }
                
                v.layer.transform = CATransform3DMakeScale(ANIMATION_SCALE, ANIMATION_SCALE, ANIMATION_SCALE);
                
                [view insertSubview:v atIndex:0];
                [topViewController viewDidAppear:animated];
            }
            
            [UIView beginAnimations:nil context:topViewController];
            [UIView setAnimationDuration:ANIMATION_DURATION];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popViewControllerAnimationDidStopAction:finished:context:)];
            
            v.layer.mask = nil;
            v.layer.transform = CATransform3DIdentity;
            
            [v setFrame:CGRectMake(0, 0, size.width, size.height)];
            
            [UIView commitAnimations];
            
        }
        else{
            if([topViewController isViewLoaded]){
                UIView * v = [topViewController view];
                if(v.superview){
                    [topViewController viewWillDisappear:animated];
                    [v removeFromSuperview];
                    [topViewController viewDidDisappear:animated];
                }
            }
            
            [_viewControllers removeLastObject];
            
            topViewController = [_viewControllers lastObject];
            
            if([self isViewLoaded]){
                UIView * topView = [topViewController view];
                [self.view addSubview:topView];
                CGSize size = self.view.bounds.size;
                [topView setFrame:CGRectMake(0, 0, size.width, size.height)];
                [topView setUserInteractionEnabled:YES];
            }
            
        }
    }
}

-(void) pushViewControllerAnimationDidStopAction:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    _animating = NO;
}

-(void) pushViewControllerAnimationTopDidStopAction:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIViewController * viewController = (UIViewController *) context;
    
    UIView * v = [viewController view];
    
    [v removeFromSuperview];
    
    v.layer.mask = nil;
    v.layer.transform = CATransform3DIdentity;
    
    [viewController viewDidDisappear:YES];
   
}

-(void) pushViewController:(UIViewController *) viewController animated:(BOOL)animated{
    
    if(_animating){
        return;
    }
    
    if(_viewControllers == nil){
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    if(animated && [self isViewLoaded]){
        
        _animating  = YES;
        
        UIView * view = self.view;
        CGSize size = view.bounds.size;
        
        
        UIViewController * topViewController = [_viewControllers lastObject];
        
        if(topViewController){
            
            UIView * v = [topViewController view];
            
            [topViewController viewWillDisappear:animated];
            
            [UIView beginAnimations:nil context:topViewController];
            [UIView setAnimationDuration:ANIMATION_DURATION];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(pushViewControllerAnimationTopDidStopAction:finished:context:)];
            
            if(v.layer.mask == nil){
                CALayer * mask = [[CALayer alloc] init];
                mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:ANIMATION_ALPHA].CGColor;
                mask.frame = v.layer.bounds;
                v.layer.mask = mask;
                [mask release];
            }
            else{
                v.layer.mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:ANIMATION_ALPHA].CGColor;
            }
            
            v.layer.transform = CATransform3DMakeScale(ANIMATION_SCALE, ANIMATION_SCALE, ANIMATION_SCALE);
            
            [UIView commitAnimations];
        }
        
        
        UIView * v = [viewController view];
        
        [viewController viewWillAppear:animated];
        
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        if(v.superview != view){
            [v setFrame:CGRectMake(size.width, 0, size.width, size.height)];
            [viewController viewWillAppear:animated];
            [view addSubview:v];
            [viewController viewDidAppear:animated];
        }
      
        [UIView beginAnimations:nil context:viewController];
        [UIView setAnimationDuration:ANIMATION_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pushViewControllerAnimationDidStopAction:finished:context:)];
        
        [v setFrame:CGRectMake(0, 0, size.width, size.height)];
        v.layer.mask = nil;
        v.layer.transform = CATransform3DIdentity;
        
        [UIView commitAnimations];
        
        
        [_viewControllers addObject:viewController];
        
    }
    else{
        
        UIViewController * topViewController = [_viewControllers lastObject];
        if([topViewController isViewLoaded]){
            UIView * v = [topViewController view];
            if(v.superview){
                [topViewController viewWillDisappear:animated];
                [v removeFromSuperview];
                [topViewController viewDidDisappear:animated];
            }
        }
        
        [_viewControllers addObject:viewController];
        
        topViewController = viewController;
        
        if([self isViewLoaded]){
            UIView * topView = [topViewController view];
            [self.view addSubview:topView];
            CGSize size = self.view.bounds.size;
            [topView setFrame:CGRectMake(0, 0, size.width, size.height)];
            [topView setUserInteractionEnabled:YES];
        }
    
    }
    
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

-(void) receiveUrl:(NSURL *) url source:(id) source{
    if([self.topViewController respondsToSelector:@selector(receiveUrl:source:)]){
        [(id)self.topViewController receiveUrl:url source:source];
    }
}


-(void) setPaths:(NSArray * ) paths animated:(BOOL) animated{
    
    NSMutableArray * newViewControllers= [ NSMutableArray arrayWithCapacity:4];
    
    NSInteger index = 0;
    NSString * basePath = [self.basePath stringByAppendingPathComponent:self.alias];
    
    while(index < [paths count] && index < [_viewControllers count]){
        
        NSString * alias = [paths objectAtIndex:index];
        
        id viewController = [_viewControllers objectAtIndex:index];
        
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
    
    while (i < [_viewControllers count]) {
        id viewController = [_viewControllers objectAtIndex:i];
        [viewController setParentController:nil];
        i++;
    }
    
    while(index < [paths count]){
        
        NSString * alias = [paths objectAtIndex:index];
        
        id viewController = [self.context getViewController:self.url basePath:basePath];
        
        [viewController setParentController:self];
        [newViewControllers addObject:viewController];
        
        basePath = [basePath stringByAppendingPathComponent:alias];
        
        index ++;
    }
    
    [self setViewControllers:newViewControllers animated:animated];
}

-(void) reloadURL{
    NSString * path = [self.url firstPathComponent:[self.basePath stringByAppendingPathComponent:self.alias]];
    [self setPaths:[NSArray arrayWithObject:path] animated:NO];
}

-(BOOL) canOpenUrl:(NSURL *) url{
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"nav";
    }
    
    if([[url scheme] isEqualToString:scheme]){
        return YES;
    }
    return [self.parentController canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"nav";
    }
    
    if([[url scheme] isEqualToString:scheme]){
        
        NSLog(@"%@",[url absoluteString]);
        
        NSString * basePath = [self.basePath stringByAppendingPathComponent:self.alias];
        
        if([[url path] hasPrefix:basePath]){
            
            NSArray * paths = [url pathComponents:basePath];
            
            if([paths count] >0){
                
                self.url = url;
                
                [self setPaths:[self.url pathComponents:[self.basePath stringByAppendingPathComponent:self.alias]] animated:animated];
                
                if([self.topViewController respondsToSelector:@selector(receiveUrl:source:)]){
                    [(id)self.topViewController receiveUrl:url source:self];
                }
                
                return YES;
            }
        }
    }
    return [self.parentController openUrl:url animated:animated];
}

-(void) setViewControllers:(NSArray *) viewControllers animated:(BOOL)animated{
    NSInteger index = 0;
    while(index < [viewControllers count] && index < [_viewControllers count]){
        id viewController1 = [viewControllers objectAtIndex:index];
        id viewController2 = [viewControllers objectAtIndex:index];
        if(viewController1 != viewController2){
            break;
        }
        index ++;
    }
    
    if(index < [viewControllers count]){
        while(index < [_viewControllers count]){
            [self popViewController:NO];
        }
        while(index + 1 < [viewControllers count]){
            [self pushViewController:[viewControllers objectAtIndex:index] animated:NO];
            index ++;
        }
        if(index < [viewControllers count]){
            [self pushViewController:[viewControllers objectAtIndex:index] animated:animated];
        }
    }
    else {
        while(index + 1 < [_viewControllers count]){
            [self popViewController:NO];
        }
        if(index < [_viewControllers count]){
            [self popViewController:animated];
        }
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
