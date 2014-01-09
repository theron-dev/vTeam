//
//  IVTChartView.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTChart.h>

@protocol IVTChartView <IVTChartAnimation>

@property(nonatomic,retain) id<IVTChart> chart;

@end
