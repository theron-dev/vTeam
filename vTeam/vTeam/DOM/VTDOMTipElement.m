//
//  VTDOMTipElement.m
//  vTeam
//
//  Created by zhang hailong on 14-8-13.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMTipElement.h"

#import "VTDOMElement+Style.h"

@implementation VTDOMTipElement


-(void) endAnimated{

    if([self isViewLoaded]){
        [self.view setHidden:YES];
    }
    
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    
    if(delegate && [self isViewLoaded]){
    
        [self.view setHidden:NO];
        [self.view setAlpha:1.0];
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:[self floatValueForKey:@"duration"]];
        [UIView setAnimationDelay:[self floatValueForKey:@"delay"]];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endAnimated)];
        
        [self.view setAlpha:0.0];
            
        [UIView commitAnimations];
    }
    else if([self isViewLoaded]){
        [self.view.layer removeAllAnimations];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}
@end
