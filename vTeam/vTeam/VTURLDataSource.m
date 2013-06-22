//
//  VTURLDataSource.m
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTURLDataSource.h"

@implementation VTURLDataSource

@synthesize url = _url;
@synthesize source = _source;

-(void) dealloc{
    [self.context cancelHandle:@protocol(IVTURLDownlinkTask) task:self];
    [_url release];
    [super dealloc];
}

-(void) reloadData{
    [super reloadData];
    
    [self.context handle:@protocol(IVTURLDownlinkTask) task:self priority:0];
}

-(void) loadMoreData{
    [super loadMoreData];
    
    [self.context handle:@protocol(IVTURLDownlinkTask) task:self priority:0];
}

-(void) cancel{
    [super cancel];
    
    [self.context cancelHandle:@protocol(IVTURLDownlinkTask) task:self];
}

@end
