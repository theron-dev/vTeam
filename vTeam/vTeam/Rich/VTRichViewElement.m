//
//  VTRichViewElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTRichViewElement.h"

@implementation VTRichViewElement

@synthesize width = _width;
@synthesize ascent = _ascent;
@synthesize descent = _descent;
@synthesize view = _view;

-(CGSize) size{
    return CGSizeMake(_width, _ascent + _descent);
}

-(void) setSize:(CGSize)size{
    _width = size.width;
    _ascent = size.height;
    _descent = 0;
}

@end
