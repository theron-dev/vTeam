//
//  VTChartTipLabel.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartTipLabel.h"

@implementation VTChartTipLabel

-(void) dealloc{
    [_font release];
    [_title release];
    [_titleColor release];
    [_backgroundColor release];
    [_lineColor release];
    [_borderColor release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    [super drawToContext:ctx rect:rect];
    
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextSetLineWidth(ctx, _borderWidth);
    CGContextSetFillColorWithColor(ctx, _backgroundColor.CGColor);
    
    CGContextSetAlpha(ctx, self.animationValue);
    
    CGContextAddRect(ctx, rect);
    
    if(_backgroundColor){
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
    else{
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    CGSize size = self.size;

    if(_toLocation.x != 0.0f || _toLocation.y != 0.0f){
        
        CGPoint p = CGPointMake(rect.origin.x + size.width * self.anchor.x
                                , rect.origin.y + size.height * self.anchor.y);
        
        CGPoint p2 = CGPointMake(p.x + _toLocation.x, p.y + _toLocation.y);
        
        CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
        CGContextSetLineWidth(ctx, _lineWidth);
        
        if(_toLocation.x >= 0.0f ){
            
            CGContextMoveToPoint(ctx, rect.origin.x + size.width - _padding.right , p.y);
            
            CGContextAddLineToPoint(ctx, rect.origin.x + size.width , p.y);
            
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            
            CGContextDrawPath(ctx, kCGPathStroke);
            
        }
        else{
            
            CGContextMoveToPoint(ctx, rect.origin.x + _padding.left, p.y);
            
            CGContextAddLineToPoint(ctx, rect.origin.x, p.y);
            
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            
            CGContextDrawPath(ctx, kCGPathStroke);
            
        }
    }
    
    CGContextSetStrokeColorWithColor(ctx, _titleColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _titleColor.CGColor);
    
    CGRect textRect = CGRectMake(_padding.left, _padding.top
                                 , size.width - _padding.left - _padding.right, size.height - _padding.top - _padding.bottom);
    
    UIGraphicsPushContext(ctx);
    
    [_title drawInRect:textRect withFont:_font lineBreakMode:NSLineBreakByTruncatingTail];
    
    UIGraphicsPopContext();
    
}

-(void) sizeToFit{
    CGSize size = [_title sizeWithFont:_font];
    [self setSize:CGSizeMake(size.width + _padding.left + _padding.right , size.height + _padding.top + _padding.bottom)];
}

-(void) setToPosition:(CGPoint) position{
    _toLocation.x = position.x - self.position.x;
    _toLocation.y = position.y - self.position.y;
}

@end
