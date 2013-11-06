//
//  VTStatusDataSource.m
//  vTeam
//
//  Created by zhang hailong on 13-11-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTStatusDataSource.h"

@implementation VTStatusDataSource

@synthesize status = _status;

-(void) dealloc{
    [_status release];
    [super dealloc];
}
    
@end
