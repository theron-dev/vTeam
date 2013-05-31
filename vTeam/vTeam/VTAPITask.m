//
//  VTAPITask.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAPITask.h"

@implementation VTAPITask

@synthesize task = _task;
@synthesize taskType = _taskType;
@synthesize userInfo = _userInfo;

-(void) dealloc{
    [_task release];
    [_userInfo release];
    [super dealloc];
}
@end
