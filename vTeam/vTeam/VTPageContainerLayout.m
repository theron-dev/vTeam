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
        [itemRects addObject:[NSValue valueWithCGRect:CGRectMake(i * size.width, 0, size.width, size.height)]];
    }
    
    self.itemRects = itemRects;
}

@end
