//
//  VTStyle.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStyle.h>

@implementation VTStyle


@synthesize name = _name;
@synthesize key = _key;
@synthesize value = _value;
@synthesize imageValue = _imageValue;
@synthesize fontValue = _fontValue;
@synthesize edgeValue = _edgeValue;

-(void) dealloc{
    [_name release];
    [_key release];
    [_value release];
    [_imageValue release];
    [_fontValue release];
    [super dealloc];
}

@end
