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

-(void) dealloc{
    [_title release];
    [_view release];
    [_cells release];
    [super dealloc];
}

@end
