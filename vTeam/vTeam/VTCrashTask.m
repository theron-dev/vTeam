//
//  VTCrashTask.m
//  vTeam
//
//  Created by zhang hailong on 13-11-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTCrashTask.h"

@implementation VTCrashTask

@synthesize exception = _exception;

-(void) dealloc{
    [_exception release];
    [super dealloc];
}

@end
