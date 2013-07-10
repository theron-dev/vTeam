//
//  VTTableSection.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableSection.h"

@implementation VTTableSection

@synthesize height=  _height;
@synthesize title = _title;
@synthesize view = _view;
@synthesize cells = _cells;
@synthesize footerView = _footerView;

-(void) dealloc{
    [_title release];
    [_view release];
    [_cells release];
    [_footerView release];
    [super dealloc];
}

@end
