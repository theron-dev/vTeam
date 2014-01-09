//
//  IVTChartComponent.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTChartDraw.h>
#import <vTeam/IVTChartAnimation.h>

@protocol IVTChartComponent <IVTChartDraw,IVTChartAnimation>

@property(nonatomic,assign) CGPoint position;
@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) CGPoint anchor;

-(CGRect) frameInRect:(CGRect) rect;

@end
