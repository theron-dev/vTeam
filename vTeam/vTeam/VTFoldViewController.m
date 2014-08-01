//
//  VTFoldViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFoldViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "NSURL+QueryValue.h"

#define FOLD_SIZE   56
#define ANIMATION_DURATION  0.3
#define ANIMATION_SCALE     1.0
#define ANIMATION_ALPHA     0.8

typedef enum _VTFoldViewDirection{
    VTFoldViewDirectionNone,VTFoldViewDirectionLeft,VTFoldViewDirectionRight
}VTFoldViewDirection;

NSString * VTFoldViewControllerToCenterNotification = @"VTFoldViewControllerToCenterNotification";


@interface VTFoldView  : UIView

@property(nonatomic,assign) BOOL beginTouch;
@property(nonatomic,assign) CGPoint prePoint;
@property(nonatomic,assign) CGPoint beginPoint;
@property(nonatomic,assign) VTFoldViewDirection direction;
@property(nonatomic,assign) id delegate;

@end

@protocol VTFoldViewDelegate

@optional

-(void) foldViewDidBegin:(VTFoldView *) foldView;

-(void) foldView:(VTFoldView *) foldView didMovedFrom:(CGPoint) fromPoint to:(CGPoint) toPoint;

-(void) foldViewDidEnd:(VTFoldView *) foldView;

@end

@implementation VTFoldView

@synthesize beginTouch = _beginTouch;
@synthesize prePoint = _prePoint;
@synthesize beginPoint = _beginPoint;
@synthesize direction = _direction;
@synthesize delegate = _delegate;

-(void) dealloc{
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame delegate:(id)controller{
    if((self = [super initWithFrame:frame])){
        UIPanGestureRecognizer * gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [gestureRecognizer setMinimumNumberOfTouches:1];
        [gestureRecognizer setMaximumNumberOfTouches:1];
        [gestureRecognizer setCancelsTouchesInView:NO];
        [self addGestureRecognizer:gestureRecognizer];
        gestureRecognizer.delegate = controller;
        [gestureRecognizer release];
    }
    return self;
}

-(void) panGestureRecognizerAction:(UIPanGestureRecognizer *) gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if(!_beginTouch){
            _beginTouch = YES;
            _beginPoint = [gestureRecognizer locationInView:self];
            _prePoint = _beginPoint;
            _direction = VTFoldViewDirectionNone;
            
            [gestureRecognizer setTranslation:_beginPoint inView:self];
            
            if([(id)_delegate respondsToSelector:@selector(foldViewDidBegin:)]){
                [_delegate foldViewDidBegin:self];
            }
        }
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        if(_beginTouch){
            CGPoint p = [gestureRecognizer translationInView:self];
            CGFloat d = p.x - _prePoint.x;
            _prePoint = p;
            if(d >0 ){
                _direction = VTFoldViewDirectionRight;
            }
            else if(d < 0){
                _direction = VTFoldViewDirectionLeft;
            }
            if([(id)_delegate respondsToSelector:@selector(foldView:didMovedFrom:to:)]){
                [_delegate foldView:self didMovedFrom:_beginPoint to:p];
            }
        }
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed){
        if(_beginTouch){
            _beginTouch = NO;
            if([(id)_delegate respondsToSelector:@selector(foldViewDidEnd:)]){
                [_delegate foldViewDidEnd:self];
            }
        }
    }
    
}

@end

@interface VTFoldViewController ()

@property(nonatomic,retain) UIViewController<IVTUIViewController> * leftViewController;
@property(nonatomic,retain) UIViewController<IVTUIViewController> * centerViewController;
@property(nonatomic,retain) UIViewController<IVTUIViewController> * rightViewController;
@property(nonatomic,assign) CGRect beginRect;
@property(nonatomic,retain) UITapGestureRecognizer * tapGestureRecognizer;
@property(nonatomic,assign) CGSize layoutSize;

@end

@interface VTFoldViewController ()

@end

@implementation VTFoldViewController


@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;
@synthesize centerViewController = _centerViewController;
@synthesize beginRect = _beginRect;
@synthesize animating = _animating;
@synthesize dragging = _dragging;
@synthesize layoutSize =_layoutSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) loadView{
    VTFoldView * foldView = [[VTFoldView alloc] initWithFrame:[UIScreen mainScreen].bounds delegate:self];
    [foldView setExclusiveTouch:YES];
    [foldView setClipsToBounds:YES];
    [foldView setDelegate:self];
    [self setView:foldView];
    [foldView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)] autorelease];
    
    self.tapGestureRecognizer.delegate = self;
    
}

-(void) tapGestureRecognizerAction:(UITapGestureRecognizer *) gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        UIView * leftView = [[self leftViewController] view];
        UIView * rightView = [[self rightViewController] view];
        
        if(leftView.superview || rightView.superview){
            [self focusCenter:YES];
        }
        
        [self.view removeGestureRecognizer:gestureRecognizer];
    }
}


-(void) viewDidUnload{
    
    UIView * centerView = [[self centerViewController] view];
    
    if(centerView){
        [centerView removeFromSuperview];
    }
    
    [super viewDidUnload];
    
    self.tapGestureRecognizer = nil;
    self.leftViewController = nil;
    self.rightViewController = nil;
    self.centerViewController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.tapGestureRecognizer = nil;
    self.leftViewController = nil;
    self.centerViewController = nil;
    self.rightViewController = nil;
    [super dealloc];
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(!CGSizeEqualToSize(self.view.bounds.size, _layoutSize)){
        
        _layoutSize = self.view.bounds.size;
        
        UIView * leftView = [[self leftViewController] view];
        UIView * rightView = [[self rightViewController] view];
        
        if(leftView.superview){
            [self focusLeft:YES];
        }
        else if(rightView.superview){
            [self focusRight:YES];
        }
        else{
            [self focusCenter:YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if(_animating ){
        return NO;
    }
    
    if(_tapGestureRecognizer != gestureRecognizer &&  [[[self topController] valueForKeyPath:@"config.fold.disabled"] boolValue]){
        return NO;
    }
    
    CGPoint point = [touch locationInView:[[self centerViewController] view]];
    CGRect centerViewFrame = [[[self centerViewController] view] bounds];
    if (CGRectContainsPoint(centerViewFrame, point)) {
        return YES;
    }
    return NO;
}

-(void) foldViewDidBegin:(VTFoldView *) foldView{
    UIView * centerView = [[self centerViewController] view];
    _beginRect = centerView.frame;
}

-(void) foldView:(VTFoldView *) foldView didMovedFrom:(CGPoint) fromPoint to:(CGPoint) toPoint{
    
    _dragging = YES;
    
    UIView * leftView = [[self leftViewController] view];
    UIView * centerView = [[self centerViewController] view];
    UIView * rightView = [[self rightViewController] view];
    
    CGRect r = _beginRect;
    CGSize size = self.view.bounds.size;
    
    r.origin.x += toPoint.x - fromPoint.x;
    
    if (r.origin.x > size.width - FOLD_SIZE) {
        r.origin.x = size.width - FOLD_SIZE;
    }
    else if (r.origin.x < - size.width + FOLD_SIZE)
    {
        r.origin.x = -size.width + FOLD_SIZE;
    }

    if(r.origin.x >0 && leftView){
        
        if(leftView.superview == nil){
            
            if([[[self.topController config] valueForKeyPath:@"fold.disabledLeft"] boolValue]){
                return;
            }
            
            [self.view insertSubview:leftView atIndex:0];
            [leftView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        
        [centerView setFrame:r];
        
        [self.view bringSubviewToFront:centerView];
        
        [rightView removeFromSuperview];
        
        CGSize size = self.view.bounds.size;
        
        CGFloat d = r.origin.x / size.width;
        
        CGFloat scale = ANIMATION_SCALE + (1.0 - ANIMATION_SCALE) * d;
        CGFloat alpha = ANIMATION_ALPHA + (1.0 - ANIMATION_ALPHA) * d;
        
        CGSize s = CGSizeMake(size.width * scale, size.height * scale);
        
        [leftView setFrame:CGRectMake((size.width - s.width) * 0.5, (size.height - s.height) * 0.5
                                      , s.width, s.height)];
        
        [leftView setAlpha:alpha];
        [leftView setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        [leftView setUserInteractionEnabled:YES];
        [centerView setUserInteractionEnabled:NO];
    }
    else if(r.origin.x <0 && rightView){

        if(rightView.superview == nil){
            
            if([[[self.topController config] valueForKeyPath:@"fold.disabledRight"] boolValue]){
                return;
            }
            
            [self.view insertSubview:rightView atIndex:0];
            [rightView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        
        [centerView setFrame:r];

        [self.view bringSubviewToFront:centerView];
        
        [leftView removeFromSuperview];
        
        CGSize size = self.view.bounds.size;
        
        CGFloat d = r.origin.x / size.width;
        
        CGFloat scale = ANIMATION_SCALE - (1.0 - ANIMATION_SCALE) * d;
        CGFloat alpha = ANIMATION_ALPHA - (1.0 - ANIMATION_ALPHA) * d;
        
        CGSize s = CGSizeMake(size.width * scale, size.height * scale);
        
        [rightView setFrame:CGRectMake((size.width - s.width) * 0.5, (size.height - s.height) * 0.5
                                       , s.width, s.height)];
        
        [rightView setAlpha:alpha];
        [rightView setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        [rightView setUserInteractionEnabled:YES];
        [centerView setUserInteractionEnabled:NO];
    }
    
}

-(void) focusLeft:(BOOL) animated{
    
    if(_animating){
        return;
    }
    
    UIView * leftView = [[self leftViewController] view];
    UIView * centerView = [[self centerViewController] view];
    UIView * rightView = [[self rightViewController] view];
    
    if(leftView && centerView){
        
        [self.view removeGestureRecognizer:_tapGestureRecognizer];
        
        //[self.leftViewController viewWillAppear:animated];
        if(leftView.superview == nil){
            [self.view addSubview:leftView];
            [leftView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        if(centerView.superview == nil){
            [self.view addSubview:centerView];
            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        
        [self.view bringSubviewToFront:centerView];
        
        //[self.rightViewController viewWillDisappear:animated];
        [rightView removeFromSuperview];
        
        //[self.leftViewController viewDidAppear:animated];
        //[self.rightViewController viewDidDisappear:animated];
        
        CGSize size = self.view.bounds.size;
        
        
        [leftView setUserInteractionEnabled:YES];
        
        [centerView setUserInteractionEnabled:NO];
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(_toLeftAnimatedDidStop)];
            [self.view setUserInteractionEnabled:NO];
        }
        
        [centerView setFrame:CGRectMake(size.width - FOLD_SIZE, 0, size.width, size.height)];
        
        [leftView setAlpha:1.0];
        [leftView setTransform:CGAffineTransformIdentity];
        [leftView setFrame:CGRectMake(0, 0, size.width, size.height)];
        
        if(animated){
            _animating = YES;
            [UIView commitAnimations];
        }
        else{
            _animating = NO;
            [self.view addGestureRecognizer:_tapGestureRecognizer];
        }
    
    }
}

-(void) focusRight:(BOOL) animated{
    
    if(_animating){
        return;
    }
    
    UIView * leftView = [[self leftViewController] view];
    UIView * centerView = [[self centerViewController] view];
    UIView * rightView = [[self rightViewController] view];
    
    if(rightView && centerView){
        
         [self.view removeGestureRecognizer:_tapGestureRecognizer];
        
//        [self.rightViewController viewWillAppear:animated];
        if(rightView.superview == nil){
            [self.view addSubview:rightView];
            [rightView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        if(centerView.superview == nil){
            [self.view addSubview:centerView];
            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        
        [self.view bringSubviewToFront:centerView];
        
//        [self.leftViewController viewWillDisappear:animated];
        [leftView removeFromSuperview];
        
//        [self.rightViewController viewDidAppear:animated];
//        [self.leftViewController viewDidDisappear:animated];
        
        CGSize size = self.view.bounds.size;
        
        [rightView setUserInteractionEnabled:YES];
        
        [centerView setUserInteractionEnabled:NO];
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(_toRightAnimatedDidStop)];
            [self.view setUserInteractionEnabled:NO];
        }
        
        [centerView setFrame:CGRectMake(FOLD_SIZE - size.width, 0, size.width, size.height)];
        
        [rightView setAlpha:1.0];
        [rightView setTransform:CGAffineTransformIdentity];
        [rightView setFrame:CGRectMake(0, 0, size.width, size.height)];
        
        if(animated){
            _animating = YES;
            [UIView commitAnimations];
        }
        else{
            _animating = NO;
            [self.view addGestureRecognizer:_tapGestureRecognizer];
        }
        
       
        
    }
}

-(void) focusCenter:(BOOL) animated{
    
    if(_animating){
        return;
    }
    
    UIView * leftView = [[self leftViewController] view];
    UIView * centerView = [[self centerViewController] view];
    UIView * rightView = [[self rightViewController] view];
    
    if(centerView){
        
        if(centerView.superview == nil){
            [self.view addSubview:centerView];
            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        }
        
        [self.view bringSubviewToFront:centerView];
        
        CGSize size = self.view.bounds.size;
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDidStopSelector:@selector(_toCenterAnimatedDidStop)];
            [UIView setAnimationDelegate:self];
            [self.view setUserInteractionEnabled:NO];
        }
        
        [centerView setFrame:CGRectMake(0, 0, size.width, size.height)];
        
        if(animated){
            
            _animating = YES;
            
            [UIView commitAnimations];
        }
        else{
            
            _animating = NO;
            
            [centerView setUserInteractionEnabled:YES];
            if(leftView.superview){
//                [self.leftViewController viewWillDisappear:animated];
                [leftView removeFromSuperview];
//                [self.leftViewController viewDidDisappear:animated];
            }
            if(rightView.superview){
//                [self.rightViewController viewWillDisappear:animated];
                [rightView removeFromSuperview];
//                [self.rightViewController viewDidDisappear:animated];
            }
        }
        
        [self.view removeGestureRecognizer:_tapGestureRecognizer];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VTFoldViewControllerToCenterNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"sender"]];

    }
}

-(void) foldViewDidEnd:(VTFoldView *) foldView{
    
    _dragging = NO;
    
    UIView * leftView = [[self leftViewController] view];
    UIView * rightView = [[self rightViewController] view];
    
    if(foldView.direction == VTFoldViewDirectionLeft){
        if(rightView.superview){
            [self focusRight:YES];
        }
        else if(leftView.superview){
            [self focusCenter:YES];
        }
    }
    else if(foldView.direction == VTFoldViewDirectionRight){
        if(leftView.superview){
            [self focusLeft:YES];
        }
        else if(rightView.superview){
            [self focusCenter:YES];
        }
    }
    
}


-(void) _toCenterAnimatedDidStop{
    _animating = NO;
    UIView * leftView = [[self leftViewController] view];
    UIView * centerView = [[self centerViewController] view];
    UIView * rightView = [[self rightViewController] view];
    [centerView setUserInteractionEnabled:YES];
    if(leftView.superview){
//        [self.leftViewController viewWillDisappear:YES];
        [leftView removeFromSuperview];
//        [self.leftViewController viewDidDisappear:YES];
    }
    if(rightView.superview){
//        [self.rightViewController viewWillDisappear:YES];
        [rightView removeFromSuperview];
//        [self.rightViewController viewDidDisappear:YES];
    }
    [self.view setUserInteractionEnabled:YES];
}

-(void) _toLeftAnimatedDidStop{
    _animating = NO;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

-(void) _toRightAnimatedDidStop{
    _animating = NO;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

-(void) setConfig:(id)config{
    [super setConfig:config];
    
    id v = [config valueForKey:@"scheme"];
    
    if(v){
        self.scheme = v;
    }
    
    NSString * url = [config valueForKey:@"leftURL"];
    
    if(url){
        id viewController = [self.context getViewController:[NSURL URLWithString:url] basePath:@"/"];
        [viewController loadUrl:[NSURL URLWithString:url] basePath:@"/" animated:NO];
        [self setLeftViewController:viewController];
    }
    
    url = [config valueForKey:@"rightURL"];
    
    if(url){
        id viewController = [self.context getViewController:[NSURL URLWithString:url] basePath:@"/"];
        [viewController loadUrl:[NSURL URLWithString:url] basePath:@"/" animated:NO];
        [self setRightViewController:viewController];
    }
    
    
    
}

-(BOOL) canOpenUrl:(NSURL *)url{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"fold";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        return YES;
    }
    
    return [super canOpenUrl:url];
}

-(NSString *) loadUrl:(NSURL *)url basePath:(NSString *)basePath animated:(BOOL)animated{
    
    basePath = [basePath stringByAppendingPathComponent:self.alias];
    
    NSString * alias = [url firstPathComponent:basePath];
    
    if(alias){
        
        if(![alias isEqualToString:self.centerViewController.alias]){
            self.centerViewController = [self.context getViewController:url basePath:basePath];
        }
        
        if(self.centerViewController){
            basePath = [self.centerViewController loadUrl:url basePath:basePath animated:animated];
        }
    }
    
    return basePath;
    
}

-(BOOL) openUrl:(NSURL *)url animated:(BOOL)animated{
    
    NSString * scheme = self.scheme;
    
    if(scheme == nil){
        scheme = @"fold";
    }
    
    if([url.scheme isEqualToString:scheme]){
        
        NSString * path = [url firstPathComponent:@"/"];
        
        if([path isEqualToString:@"center"]){
            [self focusCenter:animated];
            [self.centerViewController loadUrl:url basePath:@"/" animated:animated];
        }
        else if([path isEqualToString:@"left"]){
            [self focusLeft:animated];
            [self.leftViewController loadUrl:url basePath:@"/" animated:animated];
        }
        else if([path isEqualToString:@"right"]){
            [self focusRight:animated];
            [self.rightViewController loadUrl:url basePath:@"/" animated:animated];
            
        }

        return YES;
    }

    return [super openUrl:url animated:animated];
}

-(void) setCenterViewController:(UIViewController<IVTUIViewController> *)centerViewController{
    if(_centerViewController != centerViewController){
        [_centerViewController setParentController:nil];
        [_centerViewController release];
        _centerViewController = [centerViewController retain];
        [_centerViewController setParentController:self];
    }
}

-(void) setLeftViewController:(UIViewController<IVTUIViewController> *)leftViewController{
    if(_leftViewController != leftViewController){
        [_leftViewController setParentController:nil];
        [_leftViewController release];
        _leftViewController = [leftViewController retain];
        [_leftViewController setParentController:self];
    }
}

-(void) setRightViewController:(UIViewController<IVTUIViewController> *)rightViewController{
    if(_rightViewController != rightViewController){
        [_rightViewController setParentController:nil];
        [_rightViewController release];
        _rightViewController = [rightViewController retain];
        [_rightViewController setParentController:self];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIView * centerView = [[self centerViewController] view];
    
    if(centerView){
        
        if(centerView.superview == nil && self.view.window){
            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.view addSubview:centerView];
            [self.view bringSubviewToFront:centerView];
            
            CGSize size = self.view.bounds.size;
            
            [centerView setFrame:CGRectMake(0, 0, size.width, size.height)];
            [centerView setUserInteractionEnabled:YES];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    _layoutSize = self.view.bounds.size;
    
    UIView * centerView = [[self centerViewController] view];
    
    if(centerView){
        
        if(centerView.superview == nil && self.view.window){
            [centerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.view addSubview:centerView];
            [self.view bringSubviewToFront:centerView];
            
            CGSize size = self.view.bounds.size;
            
            [centerView setFrame:CGRectMake(0, 0, size.width, size.height)];
            [centerView setUserInteractionEnabled:YES];
        }
    }
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

-(id) topController{
    return [[self centerViewController] topController];
}

@end
