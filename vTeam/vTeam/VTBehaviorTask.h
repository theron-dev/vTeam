//
//  VTBehaviorTask.h
//  vTeam
//
//  Created by zhang hailong on 13-8-1.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

// 行为记录任务

@protocol IVTBehaviorTask <IVTTask>

@property(nonatomic,retain) VTBehaviorObject * dataObject;

@end

@interface VTBehaviorTask : VTTask<IVTBehaviorTask>

@end
