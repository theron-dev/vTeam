//
//  IVTChartContainer.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTChartComponent.h>

@protocol IVTChartContainer <IVTChartComponent>

@property(nonatomic,readonly) NSArray * components;
@property(nonatomic,assign,getter = isClips) BOOL clips;

-(void) addComponent:(id<IVTChartComponent>) component;

-(void) removeComponent:(id<IVTChartComponent>) component;

-(void) removeAllComponents;

@end
