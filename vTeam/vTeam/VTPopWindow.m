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
#define ALPHA_LEVEL     0.1


static NSMutableArray * gVTPopWindows = nil;

@implementation VTPopWindow

@synthesize animating = _animating;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
        
        CGFloat scale = 1.0 - ([gVTPopWindows count] +1) * SCALE_LEVEL;
        CGFloat alpha = 1.0 - ([gVTPopWindows count] +1) * ALPHA_LEVEL;
        
        UIWindow * win = [[UIApplication sharedApplication] keyWindow];
        
        [win setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        if(win.layer.mask == nil){
            CALayer * mask = [[CALayer alloc] init];
            mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
            mask.frame = win.layer.bounds;
            win.layer.mask = mask;
            [mask release];
        }
        else{
            win.layer.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
        }
        
        scale += SCALE_LEVEL;
        alpha += ALPHA_LEVEL;
        
        for(win in gVTPopWindows){
            
            [win setTransform:CGAffineTransformMakeScale(scale, scale)];
            
            if(win.layer.mask == nil){
                CALayer * mask = [[CALayer alloc] init];
                mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
                mask.frame = win.layer.bounds;
                win.layer.mask = mask;
                [mask release];
            }
            else{
                win.layer.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
            }
            
            scale += SCALE_LEVEL;
            alpha -= ALPHA_LEVEL;
        }
        
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
    [gVTPopWindows removeObject:self];
}

-(void) closeAnimated:(BOOL) animated{
    
    if([self isAnimating]){
        return;
    }
    
    NSInteger count = [gVTPopWindows count];
    
    if(![self isHidden] && count > 0 && [gVTPopWindows indexOfObject:self] != NSNotFound){
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(_hideAnimatedStop)];
        }
        
        CGFloat scale = 1.0 - (count -1) * SCALE_LEVEL;
        CGFloat alpha = 1.0 - (count -1) * ALPHA_LEVEL;
 
        UIWindow * win = [[UIApplication sharedApplication] keyWindow];
        
        [win setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        if(count == 1){
            win.layer.mask = nil;
        }
        else if(win.layer.mask == nil){
            CALayer * mask = [[CALayer alloc] init];
            mask.backgroundColor = [UIColor colorWithWhite:1.0 alpha:alpha].CGColor;
            mask.frame = win.layer.bounds;
            win.layer.mask = mask;
            [mask release];
        }
        else{
            win.layer.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
        }
        
        scale += SCALE_LEVEL;
        alpha += ALPHA_LEVEL;
        
        NSInteger index = 1;
        
        for(win in gVTPopWindows){
            
            if(win != self){
                
                [win setTransform:CGAffineTransformMakeScale(scale, scale)];
                
                if(index == count){
                    win.layer.mask = nil;
                }
                else if(win.layer.mask == nil){
                    CALayer * mask = [[CALayer alloc] init];
                    mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
                    mask.frame = win.layer.bounds;
                    win.layer.mask = mask;
                    [mask release];
                }
                else{
                    win.layer.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:alpha].CGColor;
                }
                
                scale += SCALE_LEVEL;
                alpha += ALPHA_LEVEL;
                
                
            }
            
            index ++;
        }
        
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
