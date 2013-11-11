//
//  GridApposeDataView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "GridApposeDataView.h"

@implementation GridApposeDataView


@synthesize grid = _grid;

-(void) dealloc{
    [_grid release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [_grid drawApposeDataToContext:UIGraphicsGetCurrentContext() rect:rect];
}


-(void) setGrid:(Grid *)grid{
    if(_grid != grid){
        [_grid release];
        _grid = [grid retain];
    }
    [self setNeedsDisplay];
}


@end
