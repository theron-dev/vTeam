//
//  VTFeedbackTask.h
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTUplinkTask.h>

@protocol IVTFeedbackTask <IVTUplinkTask>

@property(nonatomic,retain) NSString * body;

@end

@interface VTFeedbackTask : VTUplinkTask<IVTFeedbackTask>

@end
