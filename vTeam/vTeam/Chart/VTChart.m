//
//  VTChart.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChart.h"

#import <QuartzCore/QuartzCore.h>


@implementation VTChart

@synthesize dataSource = _dataSource;

-(void) dealloc{
    [_dataSource release];
    [super dealloc];
}

-(void) reloadData{
    
}

-(id) initWithSize:(CGSize) size{
    if((self = [super init])){
        self.anchor = CGPointZero;
        self.position = CGPointZero;
        self.size = size;
    }
    return self;
}

@end
