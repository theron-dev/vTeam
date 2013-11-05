//
//  VTTabBarItem.m
//  vTeam
//
//  Created by zhang hailong on 13-11-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabBarItem.h"

@implementation VTTabBarItem

@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;
    
-(void) dealloc{
    [_actionViews release];
    [_actionName release];
    [_userInfo release];
    [super dealloc];
}

    
@end
