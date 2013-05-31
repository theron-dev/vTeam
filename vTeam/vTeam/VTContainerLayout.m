//
//  VTContainerLayout.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTContainerLayout.h"

@implementation VTContainerLayout

@synthesize itemRects = _itemRects;
@synthesize delegate = _delegate;
@synthesize size = _size;
@synthesize itemSize = _itemSize;

-(void) dealloc{
    [_itemRects release];
    [super dealloc];
}

-(void) reloadData{

}

-(CGRect) itemRectAtIndex:(NSInteger) index{
    if(index >=0 && index < [_itemRects count]){
        return [[_itemRects objectAtIndex:index] CGRectValue];
    }
    return CGRectZero;
}

@end
