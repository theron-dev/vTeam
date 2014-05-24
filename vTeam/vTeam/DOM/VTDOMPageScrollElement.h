//
//  VTDOMPageScrollElement.h
//  vTeam
//
//  Created by zhang hailong on 14-1-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMContainerElement.h>

@interface VTDOMPageScrollElement : VTDOMContainerElement

@property(nonatomic,readonly) NSInteger pageIndex;
@property(nonatomic,readonly) NSInteger pageSize;

@end
