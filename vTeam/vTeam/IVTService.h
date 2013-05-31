//
//  IVTService.h
//  vTeam
//
//  Created by zhang hailong on 13-4-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTServiceContext.h>


@protocol IVTService <NSObject>

@property(nonatomic,retain) id config;

@property(nonatomic,assign) id<IVTServiceContext> context;

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority;

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task;

-(BOOL) cancelHandleForSource:(id) source;

-(void) didReceiveMemoryWarning;

@end
