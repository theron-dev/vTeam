//
//  VTChartTipLabel.h
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTChartComponent.h>

@interface VTChartTipLabel : VTChartComponent

@property(nonatomic,retain) NSString * title;
@property(nonatomic,retain) UIColor * titleColor;
@property(nonatomic,retain) UIFont * font;
@property(nonatomic,retain) UIColor * backgroundColor;
@property(nonatomic,retain) UIColor * lineColor;
@property(nonatomic,assign) CGFloat lineWidth;
@property(nonatomic,assign) UIEdgeInsets padding;
@property(nonatomic,retain) UIColor * borderColor;
@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,assign) CGPoint toLocation;

-(void) sizeToFit;

-(void) setToPosition:(CGPoint) position;

@end
