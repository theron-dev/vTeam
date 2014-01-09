//
//  VTChartArc.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTChartComponent.h>

@interface VTChartArc : VTChartComponent

@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,retain) UIColor * borderColor;
@property(nonatomic,retain) UIColor * backgroundColor;
@property(nonatomic,assign) CGFloat radius;
@property(nonatomic,assign) CGFloat startAngle;
@property(nonatomic,assign) CGFloat endAngle;

@property(nonatomic,readonly) CGPoint vertex;

@property(nonatomic,readonly) CGFloat angle;

@end
