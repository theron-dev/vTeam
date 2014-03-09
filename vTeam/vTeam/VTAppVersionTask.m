//
//  VTAppVersionTask.m
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTAppVersionTask.h"

@implementation VTAppVersionTask

@synthesize level = _level;
@synthesize content = _content;
@synthesize uri = _uri;
@synthesize version = _version;

-(void) dealloc{
    [_version release];
    [_content release];
    [_uri release];
    [super dealloc];
}

@end
