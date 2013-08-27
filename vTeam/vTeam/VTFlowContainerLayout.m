//
//  VTFlowContainerLayout.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFlowContainerLayout.h"

@implementation VTFlowContainerLayout

-(void) reloadData{
    
    NSMutableArray * itemRects = [NSMutableArray arrayWithCapacity:4];
    
    NSInteger c = [self.delegate numberOfVTContainerLayout:self];
    
    CGSize size = self.size;
    
    CGPoint p = CGPointZero;
    CGFloat lineHeight = 0;
    
    for(int i=0;i<c;i++){
        
        CGSize s =  self.itemSize;
        UIEdgeInsets margin = UIEdgeInsetsZero;
        
        if([self.delegate respondsToSelector:@selector(vtContainerLayout:itemSizeAtIndex:)]){
            s = [self.delegate vtContainerLayout:self itemSizeAtIndex:i];
        }
        
        if([self.delegate respondsToSelector:@selector(vtContainerLayout:itemMarginAtIndex:)]){
            margin = [self.delegate vtContainerLayout:self itemMarginAtIndex:i];
        }
        
        if(p.x + s.width + margin.left + margin.right > size.width  ){
            p.x = 0;
            p.y += lineHeight;
            lineHeight = 0;
        }
        
        CGRect r = CGRectMake(p.x + margin.left, p.y + margin.top, s.width, s.height);
        
        [itemRects addObject:[NSValue valueWithCGRect:r]];
        
        if(s.height + margin.top + margin.right > lineHeight){
            lineHeight = s.height + margin.top + margin.right;
        }
        
        p.x += s.width + margin.left + margin.right;
        
    }
    
    self.itemRects = itemRects;
}

@end
