//
//  VTAPIRequestTask.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAPIRequestTask.h"

@implementation VTAPIRequestTask

@synthesize apiKey = _apiKey;
@synthesize apiUrl = _apiUrl;
@synthesize queryValues = _queryValues;
@synthesize body = _body;
@synthesize httpHeaders = _httpHeaders;
@synthesize httpMethod = _httpMethod;

-(void) dealloc{
    [_apiKey release];
    [_apiUrl release];
    [_queryValues release];
    [_body release];
    [_httpMethod release];
    [_httpHeaders release];
    [super dealloc];
}

@end
