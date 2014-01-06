//
//  VTAPIResponseTask.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAPIResponseTask.h"

@implementation VTAPIResponseTask

@synthesize resultsData = _resultsData;
@synthesize error = _error;
@synthesize url = _url;
@synthesize statusCode = _statusCode;

-(void) dealloc{
    [_resultsData release];
    [_error release];
    [_url release];
    [super dealloc];
}


@end
