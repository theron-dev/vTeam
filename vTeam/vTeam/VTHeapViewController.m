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

-(void) removeViewController:(id) viewController animated:(BOOL) animated;

-(void) addViewController:(id) viewController animated:(BOOL) animated;

-(void) hiddenViewController:(id) viewController animated:(BOOL) animated;

-(void) visableViewController:(id) viewController animated:(BOOL) animated;

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
    [_panGestureRecognizer setMinimumNumberOfTouches:1];
    [_panGestureRecognizer setMaximumNumberOfTouches:1];
    [_panGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
}

-(void) panGestureRecognizerAction:(UIPanGestureRecognizer * ) gestureRecognizer{
    
    UIGestureRecognizerState state = gestureRecognizer.state;

    if(_animating || [[[self topController] valueForKeyPath:@"config.heap.disabled"] boolValue]){
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
//                        [viewController viewWillAppear:NO];
                        [view insertSubview:v atIndex:0];
//                        [viewController viewDidAppear:NO];
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
                    
                    [v setUserInteractionEnabled:NO];
                    
                }
                else{
                    
                    UIView * v = [self.topViewController view];
                    
                    v.layer.mask = nil;
                    v.layer.transform = CATransform3DIdentity;
                    [v setFrame:CGRectMake( 0, 0, size.width, size.height)];
                }
                
                
            }
            else if(d < 0){

                UIView * v = [self.topViewController view];
                [v setFrame:CGRectMake(0, 0, size.width, size.height)];
            }
            
        }
    }
    else if(state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateFailed || state == UIGestureRecognizerStateCancelled){
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

                [[[self topViewController] view] setUserInteractionEnabled:YES];
                
                [self popViewController:YES];
            }
            else if(d <0 && _direction == VTHeapViewControllerPanDirectionLeft){
                
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    if([viewController isViewLoaded]){
                        UIView * v = [viewController view];
//                        [viewController viewWillDisappear:NO];
                        [v removeFromSuperview];
//                        [viewController viewDidDisappear:NO];
                    }
                }
                
                [[[self topViewController] view] setUserInteractionEnabled:YES];
                
            }
            else{
                
                if([_viewControllers count] >1){
                    
                    UIViewController * viewController = [_viewControllers objectAtIndex:[_viewControllers count] -2];
                    
                    [self hiddenViewController:viewController animated:YES];
                }
                
                UIView * v = [self.topViewController view];
                
                _animating = YES;
                
                [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                    
                    v.layer.mask = nil;
                    v.layer.transform = CATransform3DIdentity;
                    [v setFrame:CGRectMake(0, 0, size.width, size.height)];
                    
                    
                } completion:^(BOOL finished) {
                    
                    [v setUserInteractionEnabled:YES];
                    _animating = NO;
                    
                }];
               
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
    
//    [[self topViewController] viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [[self topViewController] viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [[self topViewController] viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
//    [[self topViewController] viewDidDisappear:animated];
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
    
//    [viewController viewWillDisappear:YES];
    
    UIView * v = [viewController view];
    
    [v removeFromSuperview];
    
//    [viewController viewDidDisappear:YES];
 
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
    
    if(_panBeginTouch){
        return;
    }
    
    if([_viewControllers count] > 1){
        
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
                
//                [topViewController viewWillAppear:animated];
                
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
                //[topViewController viewDidAppear:animated];
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
//                    [topViewController viewWillDisappear:animated];
                    [v removeFromSuperview];
//                    [topViewController viewDidDisappear:animated];
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
    
//    [viewController viewDidDisappear:YES];
   
}

-(void) pushViewController:(UIViewController *) viewController animated:(BOOL)animated{
    
    if(_animating){
        return;
    }
    
    if(_panBeginTouch){
        return;
    }
    
    if(_viewControllers == nil){
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    if(animated && [self isViewLoaded] && [_viewControllers count] >0){
        
        _animating  = YES;
        
        UIView * view = self.view;
        CGSize size = view.bounds.size;
        
        
        UIViewController * topViewController = [_viewControllers lastObject];
        
        if(topViewController){
            
            UIView * v = [topViewController view];
            
//            [topViewController viewWillDisappear:animated];
            
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
        
//        [viewController viewWillAppear:animated];
        
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        if(v.superview != view){
            [v setFrame:CGRectMake(size.width, 0, size.width, size.height)];
//            [viewController viewWillAppear:animated];
            [view addSubview:v];
//            [viewController viewDidAppear:animated];
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
//                [topViewController viewWillDisappear:animated];
                [v removeFromSuperview];
//                [topViewController viewDidDisappear:animated];
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
    if(_panBeginTouch){
        return NO;
    }
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate{
    if(_panBeginTouch){
        return NO;
    }
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    if(_panBeginTouch){
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            case UIInterfaceOrientationPortrait:
                return UIInterfaceOrientationMaskPortrait;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                return UIInterfaceOrientationMaskPortraitUpsideDown;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                return UIInterfaceOrientationMaskLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                return UIInterfaceOrientationMaskLandscapeRight;
                break;
            default:
                break;
        };
    }
    return [self.topViewController supportedInterfaceOrientations];
}

-(NSString *) loadUrl:(NSURL *) url basePath:(NSString *) basePath animated:(BOOL) animated{
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:_viewControllers];
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
    return [self.parentController canOpenUrl:url];
}

-(BOOL) openUrl:(NSURL *) url animated:(BOOL) animated{
    
    if(_animating){
        return NO;
    }
    
    if(_panBeginTouch){
        return NO;
    }
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"nav";
    }
    
    if([[url scheme] isEqualToString:scheme]){
        
        NSLog(@"%@",[url absoluteString]);

        [self loadUrl:url basePath:self.basePath animated:animated];
        
        return YES;

    }
    return [super openUrl:url animated:animated];
}

-(void) setViewControllers:(NSArray *) viewControllers animated:(BOOL)animated{
    
    if(_animating){
        return;
    }
    
    NSInteger index = 0;
    while(index < [viewControllers count] && index < [_viewControllers count]){
        id viewController1 = [viewControllers objectAtIndex:index];
        id viewController2 = [_viewControllers objectAtIndex:index];
        if(viewController1 != viewController2){
            break;
        }
        index ++;
    }
    
    if(index < [viewControllers count]){
        
        [self hiddenViewController:self.topViewController animated:animated];
        
        while(index < [_viewControllers count]){
            [_viewControllers removeLastObject];
        }
        while(index + 1 < [viewControllers count]){
            id viewController= [viewControllers objectAtIndex:index];
            [_viewControllers addObject:viewController];
            index ++;
        }
        if(index < [viewControllers count]){
            
            if(_viewControllers == nil){
                _viewControllers = [[NSMutableArray alloc] init];
            }
            
            id viewController= [viewControllers objectAtIndex:index];
            [_viewControllers addObject:viewController];

            [self addViewController:viewController animated:animated];
        }
    }
    else {
        
        [self removeViewController:self.topViewController animated:animated];
        
        while(index < [_viewControllers count]){
            [_viewControllers removeLastObject];
        }
        
        [self visableViewController:self.topViewController animated:animated];
        
    }
    
}

-(void) setConfig:(id)config{
    [super setConfig:config];
    
    id v = [config valueForKey:@"scheme"];
    
    if(v){
        self.scheme = v;
    }
}

-(id) topController{
    return [(id)[self topViewController] topController];
}

-(void) removeViewController:(id) viewController animated:(BOOL) animated{
    
    if(viewController == nil){
        return;
    }
    
    if(animated && [viewController isViewLoaded] && [[viewController view] window]){
       
        [viewController retain];
        
        UIView * v = [viewController view];
        
        CGRect r = [v frame];
        
//        [viewController viewWillDisappear:animated];
        
        [UIView animateWithDuration:0.3 animations:^{
           
            [v setFrame:CGRectMake(r.size.width, r.origin.y, r.size.width, r.size.height)];
            
        } completion:^(BOOL finished) {
            
            [v removeFromSuperview];
            
            [viewController release];
            
//            [viewController viewDidDisappear:animated];
            
        }];
        
    }
    else if([viewController isViewLoaded]){
        
        UIView * v = [viewController view];
        
//        [viewController viewWillDisappear:animated];
        [v removeFromSuperview];
//        [viewController viewDidDisappear:animated];
    }
}

-(void) hiddenViewController:(id) viewController animated:(BOOL) animated{
    
    if(viewController == nil){
        return;
    }
    
    
    if(animated && [viewController isViewLoaded] && [[viewController view] window]){
       
        [viewController retain];
        
        UIView * v = [viewController view];
        
//        [viewController viewWillDisappear:animated];
        
        [UIView animateWithDuration:0.3 animations:^{
            
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
            
        } completion:^(BOOL finished) {
            
            [v removeFromSuperview];
            
            v.layer.mask = nil;
            v.layer.transform = CATransform3DIdentity;
            
            [viewController release];
            
//            [viewController viewDidDisappear:animated];
            
        }];
        
    }
    else if([viewController isViewLoaded]){
        
        UIView * v = [viewController view];
        
//        [viewController viewWillDisappear:animated];
        [v removeFromSuperview];
//        [viewController viewDidDisappear:animated];
    }
    
}

-(void) visableViewController:(id) viewController animated:(BOOL) animated{
    
    if(viewController == nil){
        return;
    }
    
    if(animated && [self isViewLoaded] && self.view.window){
        
        UIView * view = self.view;
        
        CGSize size = view.bounds.size;
        
        UIView * v = [viewController view];
        
        [v setFrame:CGRectMake(0, 0, size.width, size.height)];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
//        [viewController viewWillAppear:animated];
        
        [view insertSubview:v atIndex:0];
        
        v.layer.mask = nil;
        v.layer.transform = CATransform3DMakeScale(ANIMATION_SCALE, ANIMATION_SCALE, ANIMATION_SCALE);
        
        _animating = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
        
            v.layer.transform = CATransform3DIdentity;
            [v setFrame:CGRectMake(0, 0, size.width, size.height)];
            
        } completion:^(BOOL finished) {
            
            _animating = NO;
//            [viewController viewDidAppear:animated];
            
        }];
        
    }
    else if([self isViewLoaded]){
        
        UIView * view = self.view;
        
        CGSize size = view.bounds.size;
        
        UIView * v = [viewController view];
        
        [v setFrame:CGRectMake(0, 0, size.width, size.height)];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
//        [viewController viewWillAppear:animated];
        
        [view addSubview:v];
        
//        [viewController viewDidAppear:animated];
    }
    
}

-(void) addViewController:(id) viewController animated:(BOOL) animated{
    
    if(viewController == nil){
        return;
    }
    
    if(animated && [self isViewLoaded] && self.view.window){
        
        UIView * view = self.view;
        
        CGSize size = view.bounds.size;
        
        UIView * v = [viewController view];
    
        [v setFrame:CGRectMake(size.width, 0, size.width, size.height)];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
   
//        [viewController viewWillAppear:animated];
        
        [view addSubview:v];
        
        _animating = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [v setFrame:CGRectMake(0, 0, size.width, size.height)];
            
        } completion:^(BOOL finished) {
            
            _animating = NO;
            
//            [viewController viewDidAppear:animated];
         
        }];
        
    }
    else if([self isViewLoaded]){
        
        UIView * view = self.view;
        
        CGSize size = view.bounds.size;
        
        UIView * v = [viewController view];
        
        [v setFrame:CGRectMake(0, 0, size.width, size.height)];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
//        [viewController viewWillAppear:animated];
        
        [view addSubview:v];
        
//        [viewController viewDidAppear:animated];
    }
    
}


@end
