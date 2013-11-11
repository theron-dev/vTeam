//
//  GridHeadView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "GridHeadView.h"

@implementation GridHeadView

@synthesize grid = _grid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) dealloc{
    [_grid release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [_grid drawHeadToContext:UIGraphicsGetCurrentContext() rect:rect];
}


-(void) setGrid:(Grid *)grid{
    if(_grid != grid){
        [_grid release];
        _grid = [grid retain];
    }
    [self setNeedsDisplay];
}

-(void) sizeToFit{
    CGRect r = self.frame;
    r.size.width = [_grid size].width;
    [self setFrame:r];
}

@end
