//
//  VTService.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTService.h"

@implementation VTService

@synthesize config = _config;
@synthesize context = _context;

-(void) dealloc{
    [_config release];
    [super dealloc];
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    return NO;
}

-(BOOL) cancelHandleForSource:(id) source{
    return NO;
}

-(void) didReceiveMemoryWarning{
    
}

@end
