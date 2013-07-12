//
//  VTScrollView.h
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTScrollView : UIScrollView

@end

@protocol VTScrollViewDelegate <UIScrollViewDelegate>

@optional

-(void) scrollView:(UIScrollView *) scrollView didContentOffsetChanged:(CGPoint) contentOffset;

@end
