//
//  VTPieChart.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTChart.h>
#import <vTeam/VTChartDataReader.h>

@interface VTPieChart : VTChart

@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,retain) IBOutlet VTChartDataReader * dataItemsReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * titleReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * valueReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * colorReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * borderColorReader;
@property(nonatomic,retain) IBOutlet VTChartDataReader * totalValueReader;

@property(nonatomic,retain) UIFont * font;
@property(nonatomic,retain) UIColor * titleColor;
@property(nonatomic,retain) UIColor * lineColor;

@end
