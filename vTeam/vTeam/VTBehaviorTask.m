//
//  VTBehaviorTask.m
//  vTeam
//
//  Created by zhang hailong on 13-8-1.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBehaviorTask.h"

@implementation VTBehaviorTask

@synthesize dataObject = _dataObject;

-(void) dealloc{
    [_dataObject release];
    [super dealloc];
}

@end
