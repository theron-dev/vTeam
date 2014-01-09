//
//  IVTChartDraw.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IVTChartDraw <NSObject>

-(void) drawToContext:(CGContextRef) ctx rect:(CGRect) rect;

@end
