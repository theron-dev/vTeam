//
//  VTChartArc.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartArc.h"

@implementation VTChartArc

@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize backgroundColor = _backgroundColor;
@synthesize radius = _radius;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;

-(void) dealloc{
    [_borderColor release];
    [_backgroundColor release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _backgroundColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGFloat startAngle = self.animationValue * self.startAngle;
    CGFloat endAngle = self.animationValue * self.endAngle;
    
    CGPoint p = CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f);
    CGPoint p1 = CGPointMake(p.x + cosf(startAngle) * _radius, p.y + sinf(startAngle) * _radius);
     
    CGContextMoveToPoint(ctx, p.x, p.y);
    
    CGContextAddLineToPoint(ctx, p1.x,p1.y);
    
    CGContextAddArc(ctx, p.x, p.y, _radius, startAngle, endAngle, 0);
    
    CGContextAddLineToPoint(ctx, p.x,p.y);
    
    CGContextClosePath(ctx);
     
    if(_backgroundColor){
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
    else{
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    [super drawToContext:ctx rect:rect];
}

-(void) setRadius:(CGFloat)radius{
    _radius = radius;
    [self setSize:CGSizeMake(radius * 2.0f, radius * 2.0f)];
}

-(CGPoint) vertex{
    
    CGFloat angle = _startAngle + (_endAngle - _startAngle) / 2.0f;
    CGPoint p = self.position;
    
    return CGPointMake( p.x + cosf(angle) * _radius, p.y + sinf(angle) * _radius);
}

-(CGFloat) angle{
    return _startAngle + (_endAngle - _startAngle) / 2.0f;
}

@end
