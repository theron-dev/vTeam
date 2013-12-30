//
//  VTTableView.m
//  vTeam
//
//  Created by Zhang Hailong on 13-7-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableView.h"

@implementation VTTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if(self.window){
        if([self.delegate respondsToSelector:@selector(tableView:didContentOffsetChanged:)]){
            [(id<VTTableViewDelegate>)self.delegate tableView:self didContentOffsetChanged:self.contentOffset];
        }
    }
}

-(void) didMoveToWindow{
    [super didMoveToWindow];
    if([self.delegate respondsToSelector:@selector(tableView:didMoveToWindow:)]){
        [(id<VTTableViewDelegate>)self.delegate tableView:self didMoveToWindow:self.window];
    }
}

-(void) willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    if([self.delegate respondsToSelector:@selector(tableView:willMoveToWindow:)]){
        [(id<VTTableViewDelegate>)self.delegate tableView:self willMoveToWindow:newWindow];
    }
}

@end
