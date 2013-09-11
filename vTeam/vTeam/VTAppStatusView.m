//
//  VTAppStatusView.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAppStatusView.h"

static NSMutableArray * gVTAppStatusViews = nil;

@implementation VTAppStatusView

-(id) init{
    if(self = [super init]){
        self.frame = [[UIApplication sharedApplication] statusBarFrame];
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void) show:(BOOL)animated{
    
    if(gVTAppStatusViews == nil){
        gVTAppStatusViews = [[NSMutableArray alloc] init];
    }
    
    [gVTAppStatusViews addObject:self];
    
    [self setHidden:NO];

    if(animated){
        [self setAlpha:0.0];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self setAlpha:1.0];
        
        [UIView commitAnimations];
    }
    else{
        [self setAlpha:1.0];
    }
    
}

-(void) closeDidStopAction{
    [[self retain] autorelease];
    [self setHidden:YES];
    [self setAlpha:1.0];
    [gVTAppStatusViews removeObject:self];
}

-(void) close:(BOOL)animated{
    if(animated){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(closeDidStopAction)];
        [UIView setAnimationDuration:0.3];
        
        [self setAlpha:0.0];
        
        [UIView commitAnimations];
    }
    else{
        [[self retain] autorelease];
        [self setHidden:YES];
        [self setAlpha:1.0];
        [gVTAppStatusViews removeObject:self];
    }
}

-(void) show:(BOOL)animated duration:(NSTimeInterval)duration{
    [self show:animated];
    if(animated){
        duration += 0.3;
    }
    [self performSelector:@selector(close:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration];
}

@end

@implementation VTAppStatusMessageView

-(id) initWithTitle:(NSString *)title{
    if((self = [super init])){
        UILabel * label = [[UILabel alloc] initWithFrame:self.bounds];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:[UIColor whiteColor]];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [label setText:title];
        [self addSubview:label];
        [label release];
    }
    return self;
}

@end