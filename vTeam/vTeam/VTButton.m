//
//  VTButton.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTButton.h"

@implementation VTButton

@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;

-(void) dealloc{
    [_actionViews release];
    [_actionName release];
    [_userInfo release];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
