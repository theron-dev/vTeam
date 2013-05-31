//
//  VTToolbar.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTToolbar.h"

#import <QuartzCore/QuartzCore.h>

@implementation VTToolbar

@synthesize backgroundImage = _backgroundImage;

-(void) dealloc{
    [_backgroundImage release];
    [super dealloc];
}


-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(_backgroundImage){
        [_backgroundImage drawInRect:rect];
    }
}


-(void) setBackgroundImage:(UIImage *)backgroundImage{
    if(_backgroundImage != backgroundImage){
        [_backgroundImage release];
        _backgroundImage = [backgroundImage retain];
        [self setNeedsDisplay];
    }
}

@end
