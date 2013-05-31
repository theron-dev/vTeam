//
//  VTDataOutletContainer.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataOutletContainer.h>

@implementation VTDataOutletContainer

@synthesize dataOutlets=  _dataOutlets;

-(void) dealloc{
    [_dataOutlets release];
    [super dealloc];
}

-(void) applyDataOutlet:(id) data{
    for(id dataOutlet in _dataOutlets){
        [dataOutlet applyDataOutlet:data];
    }
}

@end
