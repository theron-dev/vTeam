//
//  VTChartContainer.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartContainer.h"

@interface VTChartContainer(){
    NSMutableArray * _components;
}

@end

@implementation VTChartContainer

@synthesize components = _components;
@synthesize clips = _clips;

-(void) dealloc{
    [_components release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef) ctx rect:(CGRect) rect{

    CGContextSaveGState(ctx);
    
    [super drawToContext:ctx rect:rect];
    
    CGContextRestoreGState(ctx);
    
    for (id<IVTChartComponent> component in _components) {
        
        CGRect r = [component frameInRect:rect];
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, r.origin.x, r.origin.y);
        
        if([self isClips]){
            CGContextClipToRect(ctx, CGRectMake(0, 0, r.size.width, r.size.height));
        }

        r.origin = CGPointZero;
        
        [component drawToContext:ctx rect:r];
        
        CGContextRestoreGState(ctx);
    }
    
}


-(void) addComponent:(id<IVTChartComponent>) component{
    if(_components == nil){
        _components = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_components addObject:component];
}

-(void) removeComponent:(id<IVTChartComponent>) component{
    [_components removeObject:component];
}

-(void) removeAllComponents{
    [_components removeAllObjects];
}


@end
