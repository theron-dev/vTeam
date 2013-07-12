//
//  VTScrollView.m
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTScrollView.h"

@implementation VTScrollView

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
    if([self.delegate respondsToSelector:@selector(scrollView:didContentOffsetChanged:)]){
        [(id<VTScrollViewDelegate>)self.delegate scrollView:self didContentOffsetChanged:self.contentOffset];
    }
}

@end
