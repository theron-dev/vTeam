//
//  VTWebView.m
//  vTeam
//
//  Created by zhang hailong on 13-11-7.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTWebView.h"

@implementation VTWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        for (UIView *inScrollView in [self subviews])
        {
            if ([inScrollView isKindOfClass:[UIImageView class]])
            {
                [inScrollView removeFromSuperview];
            }
        }
        
        for (UIView *inScrollView in [[self subviews][0] subviews])
        {
            if ([inScrollView isKindOfClass:[UIImageView class]])
            {
                [inScrollView removeFromSuperview];
            }
        }

        if([self respondsToSelector:@selector(scrollView)]){
            
            UIScrollView * scrollView = [self scrollView];
            
            [scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
            
        }
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        
        for (UIView *inScrollView in [self subviews])
        {
            if ([inScrollView isKindOfClass:[UIImageView class]])
            {
                [inScrollView removeFromSuperview];
            }
        }
        
        for (UIView *inScrollView in [[self subviews][0] subviews])
        {
            if ([inScrollView isKindOfClass:[UIImageView class]])
            {
                [inScrollView removeFromSuperview];
            }
        }
        
        if([self respondsToSelector:@selector(scrollView)]){
            
            UIScrollView * scrollView = [self scrollView];
            
            [scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
            
        }
        
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

@end
