//
//  VTGatherTask.h
//  vTeam
//
//  Created by zhang hailong on 14-4-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTUplinkTask.h>

@protocol IVTGatherTask <IVTUplinkTask>

// 主任务
@property(nonatomic,assign) Protocol * taskType;
@property(nonatomic,retain) id task;

// 子任务
@property(nonatomic,readonly) NSArray * taskTypes;
@property(nonatomic,readonly) NSArray * tasks;

-(void) addTask:(id) task taskType:(Protocol *) taskType;

@end

@interface VTGatherTask : VTUplinkTask<IVTGatherTask>

@end
