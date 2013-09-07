//
//  VTAction.m
//  vTeam
//
//  Created by Zhang Hailong on 13-9-7.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAction.h"

@implementation VTAction

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
