//
//  VTFallsContainerLayout.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTContainerLayout.h>

#define VTFallsContainerLayoutMaxColumns 10

@interface VTFallsContainerLayout : VTContainerLayout

@property(nonatomic,assign) NSInteger numberOfColumn;
@property(nonatomic,assign) CGFloat columnSplitWidth;
@property(nonatomic,assign) CGFloat columnTopHeight;
@property(nonatomic,readonly) CGFloat columnWidth;

@end

@protocol VTFallsContainerLayoutDelegate <VTContainerLayoutDelegate>

@optional

-(BOOL) vtFallsContainerLayout:(VTFallsContainerLayout *) containerLayout isFillWidthAtIndex:(NSInteger) index;

@end