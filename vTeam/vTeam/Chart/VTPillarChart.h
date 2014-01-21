//
//  VTPillarChart.h
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTChart.h>
#import <vTeam/VTChartDataReader.h>

@interface VTPillarChart : VTChart

@property(nonatomic,retain) IBOutlet VTChartDataReader * dataItemsReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * titleReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * valueReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * colorReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * borderColorReader;
@property(nonatomic,retain) UIFont * font;
@property(nonatomic,retain) UIColor * titleColor;

@property(nonatomic,retain) UIColor * lineColor;
@property(nonatomic,assign) CGFloat lineWidth;
@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,assign) UIEdgeInsets padding;
@property(nonatomic,assign) CGFloat minHeight;

@end
