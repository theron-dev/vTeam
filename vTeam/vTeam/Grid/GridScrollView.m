//
//  GridScrollView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "GridScrollView.h"

@implementation GridScrollView

@synthesize gridView = _gridView;
@synthesize apposeView = _apposeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) updateApposeFrame{
    CGSize size = self.bounds.size;
    CGSize contentSize = self.contentSize;
    CGFloat left = self.contentOffset.x;
    
    if(left <0){
        left = 0;
    }
    
    if(contentSize.width > size.width && left > contentSize.width - size.width){
        left = contentSize.width - size.width;
    }
    
    [_apposeView setFrame:CGRectMake(left, 0, size.width, size.height)];
}

-(void) dealloc{
    [_gridView release];
    [_apposeView release];
    [super dealloc];
}

-(void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    [self updateApposeFrame];
}

-(void) sizeToFit{
    [_gridView sizeToFit];
    [self setContentSize:CGSizeMake(_gridView.frame.size.width, 0)];
}

-(void) setGridView:(UIView<IGridView> *)gridView{
    if(_gridView != gridView){
        [_gridView removeFromSuperview];
        [_gridView release];
        _gridView = [gridView retain];
        
        [self addSubview:_gridView];
        
        if(_apposeView){
            [self bringSubviewToFront:_apposeView];
        }
    }
}

-(void) setApposeView:(UIView<IGridView> *)apposeView{
    if(_apposeView != apposeView){
        [_apposeView removeFromSuperview];
        [_apposeView release];
        _apposeView = [apposeView retain];
        [self addSubview:_apposeView];
        
        [self updateApposeFrame];
    }
}

-(Grid *) grid{
    return [_gridView grid];
}

-(void) setGrid:(Grid *)grid{
    [_gridView setGrid:grid];
    [_apposeView setGrid:grid];
}

@end
