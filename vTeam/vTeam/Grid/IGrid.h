//
//  IGrid.h
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IGridRow.h>
#import <vTeam/IGridValue.h>
#import <vTeam/IGridColumn.h>

@protocol IGrid <NSObject,IGridValue>

@property(nonatomic,readonly) CGSize size;
@property(nonatomic,assign) CGFloat columnSplitWidth;
@property(nonatomic,retain) UIColor * columnSplitColor;
@property(nonatomic,retain) UIColor * dataSplitColor;
@property(nonatomic,assign) CGFloat rowSplitHeight;
@property(nonatomic,retain) UIColor * rowSplitColor;
@property(nonatomic,readonly) NSArray * columns;
@property(nonatomic,readonly) NSArray * dataRows;
@property(nonatomic,retain) UIColor * columnBackgroundColor;
@property(nonatomic,retain) UIColor * columnTitleColor;
@property(nonatomic,retain) UIFont * columnTitleFont;
@property(nonatomic,retain) UIColor * dataTitleColor;
@property(nonatomic,retain) UIFont * dataTitleFont;
@property(nonatomic,assign) NSInteger limitRows;
@property(nonatomic,assign) NSInteger apposeLeftColumns;
@property(nonatomic,assign) NSInteger apposeRightColumns;

-(id<IGridRow>) addDataRow:(id) data;

-(id<IGridRow>) insertDataRow:(id) data atIndex:(NSUInteger) index;

-(void) removeDataRowAt:(NSUInteger) index;

-(void) removeAllDataRows;

-(void) removeDataRow:(id<IGridRow>) row;

-(id<IGridColumn>) addColumn;

-(id<IGridColumn>) insertColumnAt:(NSUInteger) index;

-(void) removeColumnAt:(NSUInteger) index;

-(void) removeColumn:(id<IGridColumn>) column;

-(void) removeAllColumns;

-(void) updateSize;

-(void) drawDataToContext:(CGContextRef) ctx rect:(CGRect) rect;

-(void) drawHeadToContext:(CGContextRef) ctx rect:(CGRect) rect;

-(void) drawApposeHeadToContext:(CGContextRef) ctx rect:(CGRect) rect;

-(void) drawApposeDataToContext:(CGContextRef) ctx rect:(CGRect) rect;

-(void) applyCellViewTo:(UIView *) superview rect:(CGRect) rect;

@end
