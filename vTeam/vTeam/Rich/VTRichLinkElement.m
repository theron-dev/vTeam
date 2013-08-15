//
//  VTRichLinkElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTRichLinkElement.h"

@implementation VTRichLinkElement

@synthesize href = _href;

-(void) dealloc{
    [_href release];
    [super dealloc];
}

@end
