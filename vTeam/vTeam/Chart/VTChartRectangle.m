//
//  VTChartRectangle.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartRectangle.h"

@implementation VTChartRectangle

-(void) dealloc{
    [_backgroundColor release];
    [_borderColor release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _backgroundColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);
    
    CGContextAddRect(ctx, rect);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}

@end
