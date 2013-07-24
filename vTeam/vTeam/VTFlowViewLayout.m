//
//  VTFlowViewLayout.m
//  vTeam
//
//  Created by zhang hailong on 13-7-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFlowViewLayout.h"

@implementation VTFlowViewLayout

-(void) doLayout{
    
    CGSize size = self.size;
    UIEdgeInsets padding = self.padding;
    
    CGSize innerSize = CGSizeMake(size.width - padding.left - padding.right, size.height - padding.top - padding.bottom);
    CGPoint p = CGPointMake(padding.left, padding.top);
    CGFloat lineHeight = 0;
    CGFloat width = 0;
    
    for(id layoutData in self.layoutDatas){
        
        CGRect r = [layoutData frameOfSize:innerSize];
        
        if(r.size.width + p.x <= size.width - padding.right){
            r.origin = p;
            p.x += r.size.width;
            if(r.size.height > lineHeight){
                lineHeight = r.size.height;
            }
            if(p.x > width){
                width = p.x;
            }
        }
        else{
            if(lineHeight == 0){
                r.origin = p;
                p.y += r.size.height;
                if(r.origin.x + r.size.width > width){
                    width = r.origin.x + r.size.width;
                }
            }
            else{
                p.x = padding.left;
                p.y += lineHeight;
                r.origin = p;
                p.x += r.size.width;
                lineHeight = r.size.height;
                if(p.x > width){
                    width = p.x;
                }
            }
        }
        
        [[layoutData view] setFrame:r]; 
    }
    
    self.contentSize = CGSizeMake(width + padding.right, p.y + lineHeight + padding.bottom);
    
    if([self.view isKindOfClass:[UIScrollView class]]){
        [(UIScrollView *)self.view setContentSize:CGSizeMake(0, self.contentSize.height)];
    }
}

@end
