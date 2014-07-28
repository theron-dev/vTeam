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
@synthesize tag = _tag;

-(void) dealloc{
    [_title release];
    [_view release];
    [_cells release];
    [_footerView release];
    [super dealloc];
}

-(void) setCells:(NSArray *)cells{
    NSArray * c = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger tag1 = [(UIView *) obj1 tag];
        NSInteger tag2 = [(UIView *) obj2 tag];
        NSInteger r = tag1 - tag2;
        
        if(r < 0){
            return NSOrderedAscending;
        }
        if(r > 0){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    [_cells release];
    _cells = [c retain];
}

@end
