//
//  UIView+Hidden.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIView+Hidden.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Hidden)

-(void) _viewHiddenDidStop{
    [self setHidden:YES];
    [self setAlpha:1.0];
}

-(void) _viewVisableDidStop{
    [self setHidden:NO];
    [self setAlpha:1.0];
}

-(void) setHidden:(BOOL)hidden animated:(BOOL) animated{
    
    if(animated){
        
        [self setHidden:NO];
      
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        
        if(hidden){
            [UIView setAnimationDidStopSelector:@selector(_viewHiddenDidStop)];
            
            [self setAlpha:0.0];
        }
        else{
            [UIView setAnimationDidStopSelector:@selector(_viewVisableDidStop)];
            
            [self setHidden:YES];
            [self setAlpha:1.0];
        }
        
        [UIView commitAnimations];

    }
    else{
        [self.layer removeAllAnimations];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_viewVisableDidStop) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_viewHiddenDidStop) object:nil];
        [self setAlpha:1.0];
        [self setHidden:hidden];
    }
}

@end
