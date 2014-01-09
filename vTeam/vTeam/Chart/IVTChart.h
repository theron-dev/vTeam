//
//  IVTChart.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTChartContainer.h>

@protocol IVTChart <IVTChartContainer>

@property(nonatomic,retain) IBOutlet id dataSource;

-(id) initWithSize:(CGSize) size;

-(void) reloadData;

@end
