//
//  VTChartLabel.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartLabel.h"

@implementation VTChartLabel


-(void) dealloc{
    [_font release];
    [_title release];
    [_titleColor release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    [super drawToContext:ctx rect:rect];
    
    CGContextSetStrokeColorWithColor(ctx, _titleColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _titleColor.CGColor);
    
    UIGraphicsPushContext(ctx);
    
    [_title drawInRect:rect withFont:_font lineBreakMode:NSLineBreakByTruncatingTail];
    
    UIGraphicsPopContext();
    
}

-(void) sizeToFit{
    CGSize size = [_title sizeWithFont:_font];
    [self setSize:size];
}


@end
