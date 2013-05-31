//
//  VTLayoutData.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTLayoutData.h"

@implementation VTLayoutData

@synthesize view = _view;
@synthesize width = _width;
@synthesize height = _height;
@synthesize left = _left;
@synthesize right = _right;
@synthesize top = _top;
@synthesize bottom = _bottom;
@synthesize widthToFit = _widthToFit;
@synthesize heightToFit = _heightToFit;
@synthesize minWidth = _minWidth;
@synthesize maxWidth = _maxWidth;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;

-(void) dealloc{
    [_left release];
    [_right release];
    [_top release];
    [_bottom release];
    [_view release];
    [_minWidth release];
    [_maxWidth release];
    [_minHeight release];
    [_maxHeight release];
    [super dealloc];
}

-(CGFloat) value:(id) value ofBase:(CGFloat) baseValue{
    if([value isKindOfClass:[NSString class]]){
        if([value hasSuffix:@"%"]){
            return baseValue * [value floatValue] / 100.0f;
        }
    }
    return [value floatValue];
}

-(CGRect) frameOfSize:(CGSize) size{
    CGRect r = CGRectZero;
    CGRect frame = _view.frame;

    if(_widthToFit || _heightToFit){
        
        if(_widthToFit){
            frame.size.width = [self value:_minWidth ofBase:size.width];
        }
        if(_heightToFit){
            frame.size.height = [self value:_minHeight ofBase:size.height];
        }
        [_view setFrame:frame];
        [_view sizeToFit];
        frame = _view.frame;
        
        if(_maxWidth){
            CGFloat maxWidth = [self value:_maxWidth ofBase:size.width];;
            if(frame.size.width > maxWidth){
                frame.size.width = maxWidth;
            }
        }
        
        if(_maxHeight){
            CGFloat maxHeight = [self value:_maxHeight ofBase:size.height];
            if(frame.size.height > maxHeight){
                frame.size.height = maxHeight;
            }
        }
    }
    
    if(_width == nil){
        if(_left == nil || _right == nil){
            r.origin.x = frame.origin.x;
            r.size.width = frame.size.width;
        }
        else{
            r.origin.x = [self value:_left ofBase:size.width];
            r.size.width = size.width - r.origin.x - [self value:_right ofBase:size.width];
        }
    }
    else {
        r.size.width = [self value:_width ofBase:size.width];
        if(_left == nil){
            if(_right == nil){
                r.origin.x = (size.width - r.size.width) / 2.0f;
            }
            else{
                r.origin.x = size.width - [self value:_right ofBase:size.width];
            }
        }
        else{
            r.origin.x = [self value:_left ofBase:size.width];
        }
    }
    
    if(_height == nil){
        if(_top == nil || _bottom == nil){
            r.origin.y = frame.origin.y;
            r.size.height = frame.size.height;
        }
        else{
            r.origin.y = [self value:_top ofBase:size.height];
            r.size.height = size.height - r.origin.y - [self value:_bottom ofBase:size.height];
        }
    }
    else{
        r.size.height = [self value:_height ofBase:size.height];
        if(_top == nil){
            if(_bottom == nil){
                r.origin.y = (size.height - r.size.height) / 2.0f;
            }
            else{
                r.origin.y = size.height - [self value:_bottom ofBase:size.height];
            }
        }
        else{
            r.origin.y = [self value:_top ofBase:size.height];
        }
    }
    
    return r;
}

@end
