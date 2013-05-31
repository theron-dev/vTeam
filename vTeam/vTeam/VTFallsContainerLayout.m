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
    
    for(int i=0;i<c;i++){
        
        CGSize s =  self.itemSize;
        
        if([self.delegate respondsToSelector:@selector(vtContainerLayout:itemSizeAtIndex:)]){
            s = [self.delegate vtContainerLayout:self itemSizeAtIndex:i];
        }
        
        columnIndex = 0;
        columnTop = tops[columnIndex];
        
        for(int n=1;n<numberOfColumn;n++){
            if(tops[n] < columnTop){
                columnIndex = n;
                columnTop = tops[n];
            }
        }
        
        [itemRects addObject:[NSValue valueWithCGRect:CGRectMake(
                                                                 (_columnSplitWidth + columnWidth) * columnIndex + _columnSplitWidth
                                                                 , columnTop + _columnTopHeight, columnWidth, s.height)]];
        
        tops[columnIndex] += s.height + _columnTopHeight;

    }
    
    self.itemRects = itemRects;
}

@end
