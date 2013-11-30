//
//  VTTask.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>

@implementation VTTask

@synthesize source = _source;

-(id) initWithSource:(id) source{
    if((self = [super init])){
        _source = source;
    }
    return self;
}

@end
