//
//  VTFeedbackTask.m
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTFeedbackTask.h"

@implementation VTFeedbackTask

@synthesize body = _body;

-(void) dealloc{
    [_body release];
    [super dealloc];
}

@end
