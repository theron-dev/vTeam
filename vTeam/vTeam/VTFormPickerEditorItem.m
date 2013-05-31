//
//  VTFormPickerEditorItem.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormPickerEditorItem.h"

@implementation VTFormPickerEditorItem

@synthesize value = _value;
@synthesize text = _text;
@synthesize items = _items;

-(void) dealloc{
    [_value release];
    [_text release];
    [_items release];
    [super dealloc];
}

@end
