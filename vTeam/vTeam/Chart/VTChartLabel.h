//
//  VTChartLabel.h
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTChartComponent.h>

@interface VTChartLabel : VTChartComponent

@property(nonatomic,retain) NSString * title;
@property(nonatomic,retain) UIColor * titleColor;
@property(nonatomic,retain) UIFont * font;

-(void) sizeToFit;

@end
