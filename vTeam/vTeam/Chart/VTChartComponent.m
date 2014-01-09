//
//  VTChartComponent.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartComponent.h"

@implementation VTChartComponent

@synthesize position = _position;
@synthesize size = _size;
@synthesize anchor = _anchor;
@synthesize animationValue = _animationValue;

-(id) init{
    if((self = [super init])){
        _anchor = CGPointMake(0.5, 0.5);
        _animationValue = 1.0;
    }
    return self;
}

-(CGRect) frameInRect:(CGRect)rect{
    return CGRectMake(_position.x - _size.width * _anchor.x, _position.y - _size.height * _anchor.y
                      , _size.width, _size.height);
}


-(void) drawToContext:(CGContextRef) ctx rect:(CGRect) rect{
    
}

@end
