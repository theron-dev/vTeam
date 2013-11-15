//
//  VTCrashTask.h
//  vTeam
//
//  Created by zhang hailong on 13-11-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>

@protocol IVTCrashTask <IVTTask>

@property(nonatomic,retain) NSException * exception;

@end

@interface VTCrashTask : VTTask<IVTCrashTask>


@end
