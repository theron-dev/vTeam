//
//  VTAnimationView.m
//  vTeam
//
//  Created by Zhang Hailong on 13-7-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAnimationView.h"

#import <QuartzCore/QuartzCore.h>

@implementation VTAnimationView

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


- (void)startAnimating{
    
}

- (void)stopAnimating{
    
}

- (BOOL)isAnimating{
    return [[self.layer animationKeys] count] >0 ;
}

@end
