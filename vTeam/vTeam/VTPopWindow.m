//
//  VTWindow.m
//  vTeam
//
//  Created by zhang hailong on 13-5-31.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTPopWindow.h"

#import <QuartzCore/QuartzCore.h>

#define SCALE_LEVEL     0.02
#define ALPHA_LEVEL     0.05


static NSMutableArray * gVTPopWindows = nil;

@interface VTPopWindow ()

@property(nonatomic,retain) UIWindow * keyWindow;

@end

@implementation VTPopWindow

@synthesize animating = _animating;
@synthesize keyWindow = _keyWindow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) dealloc{
    [_keyWindow release];
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(VTPopWindow *) popWindow{
    VTPopWindow * win = [[VTPopWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [win setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [win setHidden:YES];
    
    return [win autorelease];
}

+(VTPopWindow *) topPopWindow{
    return [gVTPopWindows lastObject];
}

-(void) _showAnimatedStop{
    _animating = NO;
}

-(void) showAnimated:(BOOL) animated{
    
    if([self isAnimating]){
        return;
    }
    
    if([self isHidden]){

        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(_showAnimatedStop)];
        }
        
        CGFloat scale = 1.0 - SCALE_LEVEL;
        CGFloat alpha = 1.0 -  ALPHA_LEVEL;
        
        self.keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        [self makeKeyWindow];
        
        [_keyWindow setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        if(_keyWindow.layer.mask == nil){
            CALayer * mask = [[CALayer alloc] init];
            mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
            mask.frame = _keyWindow.layer.bounds;
            _keyWindow.layer.mask = mask;
            [mask release];
        }
        else{
            _keyWindow.layer.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
        }
        
        [_keyWindow setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        if(gVTPopWindows == nil){
            gVTPopWindows = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        [gVTPopWindows addObject:self];
        
        [self setTransform:CGAffineTransformIdentity];
        [self.layer setMask:nil];
        [self setHidden:NO];
        
        if(animated){
            [UIView commitAnimations];
            _animating = YES;
        }
    }
    
}

-(void) _hideAnimatedStop{
    _animating = NO;
    [self setHidden:YES];
    [gVTPopWindows removeObject:self];
}

-(void) closeAnimated:(BOOL) animated{
    
    if([self isAnimating]){
        return;
    }
    
    NSInteger count = [gVTPopWindows count];

    if(![self isHidden] && count > 0 && [gVTPopWindows indexOfObject:self] != NSNotFound){

        [[self retain] autorelease];
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(_hideAnimatedStop)];
        }
        
        [_keyWindow makeKeyWindow];
        
        _keyWindow.layer.mask = nil;
        [_keyWindow setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        
        self.keyWindow = nil;
        
        if(animated){
            [self setAlpha:0.0f];
        }
        else{
            [gVTPopWindows removeObject:self];
        }

        if(animated){
            [UIView commitAnimations];
            _animating = YES;
        }
    }
}


@end
