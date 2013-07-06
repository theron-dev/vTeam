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

-(void) didContentOffsetChanged{
    if([self.delegate respondsToSelector:@selector(tableView:didContentOffsetChanged:)]){
        [(id<VTTableViewDelegate>)self.delegate tableView:self didContentOffsetChanged:self.contentOffset];
    }
}

-(void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    if([self.delegate respondsToSelector:@selector(tableView:didContentOffsetChanged:)]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didContentOffsetChanged) object:nil];
        [self performSelector:@selector(didContentOffsetChanged) withObject:nil afterDelay:0.01];
    }
}

@end
