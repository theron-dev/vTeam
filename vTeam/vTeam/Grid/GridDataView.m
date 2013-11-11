//
//  GridDataView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "GridDataView.h"

@implementation GridDataView

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
    [_grid drawDataToContext:UIGraphicsGetCurrentContext() rect:rect];
}


-(void) setGrid:(Grid *)grid{
    if(_grid != grid){
        
        for(UIView * v in [self subviews]){
            [v removeFromSuperview];
        }
        
        [_grid release];
        _grid = [grid retain];
        
        [_grid applyCellViewTo:self rect:self.bounds];
    }
    [self setNeedsDisplay];
}

-(void) sizeToFit{
    CGRect r = self.frame;
    r.size = [_grid size];
    [self setFrame:r];
}

@end
