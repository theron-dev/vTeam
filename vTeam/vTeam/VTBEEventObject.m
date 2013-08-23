//
//  VTBEEventObject.m
//  vTeam
//
//  Created by zhang hailong on 13-8-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBEEventObject.h"

@implementation VTBEEventObject

@synthesize session = _session;
@synthesize eventId = _eventId;
@synthesize tag = _tag;

-(void) dealloc{
    [_session release];
    [_eventId release];
    [_tag release];
    [super dealloc];
}

@end
