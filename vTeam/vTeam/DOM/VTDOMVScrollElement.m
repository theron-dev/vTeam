//
//  VTDOMVScrollElement.m
//  vTeam
//
//  Created by zhang hailong on 14-1-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMVScrollElement.h"

#import "VTDOMView.h"

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"

@implementation VTDOMVScrollElement

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(size.width, 0);
    
    for (VTDOMElement * element in [self childs]) {
        
        UIEdgeInsets margin = [element margin];
        
        [element layout:CGSizeMake(size.width - margin.left - margin.right - padding.left - padding.right
                                   , size.height)];
        
        CGRect r = element.frame;
        
        r.origin = CGPointMake(padding.left + margin.left, contentSize.height + margin.top + padding.top);
        r.size.width = size.width - padding.left - padding.right - margin.left - margin.right;
        
        [element setFrame:r];
        
        contentSize.height += r.size.height + margin.top + margin.bottom;
    }
    
    contentSize.height += padding.top + padding.bottom;
    
    if(contentSize.height < size.height){
        contentSize.height = size.height;
    }
    
    [self setContentSize:contentSize];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
        [self reloadData];
    }
    
    return size;
}

@end
