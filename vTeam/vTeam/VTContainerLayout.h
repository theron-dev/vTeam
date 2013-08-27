//
//  VTContainerLayout.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTContainerLayout : NSObject

@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) NSArray * itemRects;
@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) CGSize itemSize;

-(void) reloadData;

-(CGRect) itemRectAtIndex:(NSInteger) index;

@end

@protocol VTContainerLayoutDelegate

-(NSInteger) numberOfVTContainerLayout:(VTContainerLayout *) containerLayout;

@optional

-(CGSize) vtContainerLayout:(VTContainerLayout *) containerLayout itemSizeAtIndex:(NSInteger) index;

-(UIEdgeInsets) vtContainerLayout:(VTContainerLayout *) containerLayout itemMarginAtIndex:(NSInteger) index;

@end