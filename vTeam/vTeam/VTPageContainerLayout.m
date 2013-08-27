//
//  VTPageContainerLayout.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTPageContainerLayout.h"

@implementation VTPageContainerLayout

-(void) reloadData{
    
    NSMutableArray * itemRects = [NSMutableArray arrayWithCapacity:4];
    
    NSInteger c = [self.delegate numberOfVTContainerLayout:self];
    
    CGSize size = self.size;
    
    for(int i=0;i<c;i++){
        
        UIEdgeInsets margin = UIEdgeInsetsZero;
        
        if([self.delegate respondsToSelector:@selector(vtContainerLayout:itemMarginAtIndex:)]){
            margin = [self.delegate vtContainerLayout:self itemMarginAtIndex:i];
        }
        
        [itemRects addObject:[NSValue valueWithCGRect:CGRectMake(i * size.width + margin.left, margin.top, size.width - margin.left - margin.right, size.height - margin.top - margin.bottom)]];
    }
    
    self.itemRects = itemRects;
}

@end
