//
//  IGridRow.h
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IGridCell.h>
#import <vTeam/IGridValue.h>

@protocol IGridRow <IGridDraw,IGridValue>

@property(nonatomic,assign) CGFloat height;
@property(nonatomic,readonly) NSArray * cells;
@property(nonatomic,retain) UIColor * backgroundColor;
@property(nonatomic,retain) UIColor * nextSplitColor;

-(void) applyCellViewTo:(UIView *) superview rect:(CGRect) rect;

-(void) heightToFit;

-(void) updateData:(id) data;

@end
