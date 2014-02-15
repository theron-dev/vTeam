//
//  VTFallsContainerLayout.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFallsContainerLayout.h"

@implementation VTFallsContainerLayout

@synthesize numberOfColumn = _numberOfColumn;
@synthesize columnSplitWidth = _columnSplitWidth;
@synthesize columnTopHeight = _columnTopHeight;

-(void) reloadData{
    
    NSInteger numberOfColumn = self.numberOfColumn;
    NSInteger columnIndex = 0;
    CGFloat columnTop = 0;
    
    if(numberOfColumn < 1){
        numberOfColumn = 3;
    }
    
    NSInteger tops[VTFallsContainerLayoutMaxColumns] = {0};
    
    NSMutableArray * itemRects = [NSMutableArray arrayWithCapacity:4];
    
    NSInteger c = [self.delegate numberOfVTContainerLayout:self];
    
    CGSize size = self.size;
    
    for(int n=0;n<numberOfColumn;n++){
        tops[n] = 0;
    }
    
    CGFloat columnWidth = ( size.width - (numberOfColumn +1) * _columnSplitWidth ) / numberOfColumn;
    
    id delegate = self.delegate;
    
    for(int i=0;i<c;i++){
        
        CGSize s =  self.itemSize;
        UIEdgeInsets margin = UIEdgeInsetsZero;
        BOOL isFillWidth = NO;
        
        if([delegate respondsToSelector:@selector(vtContainerLayout:itemSizeAtIndex:)]){
            s = [delegate vtContainerLayout:self itemSizeAtIndex:i];
        }
        
        if([delegate respondsToSelector:@selector(vtContainerLayout:itemMarginAtIndex:)]){
            margin = [delegate vtContainerLayout:self itemMarginAtIndex:i];
        }
        
        if([delegate respondsToSelector:@selector(vtFallsContainerLayout:isFillWidthAtIndex:)]){
            isFillWidth = [delegate vtFallsContainerLayout:self isFillWidthAtIndex:i];
        }
        
        CGRect rect ;
        
        if(isFillWidth){

            columnTop = tops[0];
            
            for(int n=1;n<numberOfColumn;n++){
                if(tops[n] > columnTop){
                    columnTop = tops[n];
                }
            }
            
            rect = CGRectMake(margin.left
                              , columnTop + _columnTopHeight + margin.top, size.width - margin.left - margin.right, s.height );
            
            columnTop += s.height + _columnTopHeight + margin.top + margin.bottom;
            
            for(int n=0;n<numberOfColumn;n++){
                tops[n] = columnTop;
            }
            
        }
        else{
            columnIndex = 0;
            columnTop = tops[columnIndex];
            
            for(int n=1;n<numberOfColumn;n++){
                if(tops[n] < columnTop){
                    columnIndex = n;
                    columnTop = tops[n];
                }
            }
            
            rect = CGRectMake(
                              (_columnSplitWidth + columnWidth) * columnIndex + _columnSplitWidth + margin.left
                              , columnTop + _columnTopHeight + margin.top, columnWidth - margin.left - margin.right, s.height );
            
            
            tops[columnIndex] += s.height + _columnTopHeight + margin.top + margin.bottom;
        }
        
        [itemRects addObject:[NSValue valueWithCGRect:rect]];
        
    }
    
    self.itemRects = itemRects;
}

-(CGFloat) columnWidth{
    
    NSInteger numberOfColumn = self.numberOfColumn;
   
    if(numberOfColumn < 1){
        numberOfColumn = 3;
    }
    
    CGSize size = self.size;
    
    return ( size.width - (numberOfColumn +1) * _columnSplitWidth ) / numberOfColumn;
}

@end
