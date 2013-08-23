//
//  VTBESessionObject.m
//  vTeam
//
//  Created by zhang hailong on 13-8-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBESessionObject.h"

#import "NSString+VTMD5String.h"

@implementation VTBESessionObject

@synthesize session = _session;
@synthesize startTimestamp = _startTimestamp;

-(void) dealloc{
    [_session release];
    [super dealloc];
}

+(NSString *) genSession{
    return [[[NSUUID UUID] UUIDString] vtMD5String];
}

@end
