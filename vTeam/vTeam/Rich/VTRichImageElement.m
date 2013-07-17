//
//  VTRichImageElement.m
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTRichImageElement.h"

@implementation VTRichImageElement

@synthesize image = _image;
@synthesize width = _width;
@synthesize ascent = _ascent;
@synthesize descent = _descent;

-(void) dealloc{
    [_image release];
    [super dealloc];
}

-(CGSize) size{
    return CGSizeMake(_width, _ascent + _descent);
}

-(void) setSize:(CGSize)size{
    _width = size.width;
    _ascent = size.width;
    _descent = 0;
}

-(void) drawRect:(CGRect)rect context:(CGContextRef)context{
    [_image drawInRect:rect];
}

@end
