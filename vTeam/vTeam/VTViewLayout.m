//
//  VTViewLayout.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTViewLayout.h"

@interface VTViewLayout(){
    BOOL _needsLayout;
}

@end

@implementation VTViewLayout

@synthesize view = _view;
@synthesize size = _size;
@synthesize padding = _padding;
@synthesize layoutDatas = _layoutDatas;

-(void) dealloc{
    [_layoutDatas release];
    [_view release];
    [super dealloc];
}

-(void) setNeedsLayout{
    _needsLayout = YES;
}

-(void) setLayoutDatas:(NSArray *)layoutDatas{
    if(_layoutDatas != layoutDatas){
        [layoutDatas retain];
        [_layoutDatas release];
        _layoutDatas = layoutDatas;
        _needsLayout = YES;
    }
}

-(void) layout{
    CGSize size = [_view bounds].size;
    
    if([_view respondsToSelector:@selector(contentSize)]){
        CGSize s = [(UIScrollView *) _view contentSize];
        if(size.width < s.width){
            size.width = s.width;
        }
        if(size.height < s.height){
            size.height = s.height;
        }
    }
    
    if(!CGSizeEqualToSize(size, _size) || _needsLayout){
        _size = size;
        [self doLayout];
    }
}

-(void) doLayout{
    
    CGSize contentSize = CGSizeZero;
    
    CGSize innerSize = CGSizeMake(_size.width - _padding.left - _padding.right, _size.height - _padding.top - _padding.bottom);
    
    for(id layoutData in _layoutDatas){
        
        CGRect r = [layoutData frameOfSize:innerSize];
        r.origin.x += _padding.left;
        r.origin.y += _padding.top;
        [[layoutData view] setFrame:r];
        
        if(contentSize.width < r.origin.x + r.size.width + _padding.right){
            contentSize.width = r.origin.x + r.size.width + _padding.right;
        }
        
        if(contentSize.height < r.origin.y + r.size.height + _padding.bottom){
            contentSize.height = r.origin.y + r.size.height + _padding.bottom;
        }
        
    }
    
    self.contentSize = contentSize;
}

@end
