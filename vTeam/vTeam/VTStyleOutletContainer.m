//
//  VTStyleContainer.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStyleOutletContainer.h>

@implementation VTStyleOutletContainer

@synthesize styles = _styles;

-(void) dealloc{
    [_styles release];
    [super dealloc];
}

-(void) setStyleSheet:(VTStyleSheet *) styleSheet{
    for(id style in _styles){
        [style setStyleSheet:styleSheet];
    }
}

@end
