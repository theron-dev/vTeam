//
//  VTAudioTask.m
//  vTeam
//
//  Created by zhang hailong on 14-1-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTAudioTask.h"

@implementation VTAudioTask

@synthesize url = _url;
@synthesize status = _status;
@synthesize cancelPlay = _cancelPlay;

-(void) dealloc{
    [_url release];
    [super dealloc];
}

@end
