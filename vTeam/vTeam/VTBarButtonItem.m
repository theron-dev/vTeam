//
//  VTBarButtonItem.m
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBarButtonItem.h"

@implementation VTBarButtonItem

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
