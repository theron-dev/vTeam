//
//  IVTDownlinkTask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTTask.h>

@protocol IVTDownlinkTask <IVTTask>

@property(nonatomic,assign,getter = isSkipCached) BOOL skipCached;
@property(nonatomic,assign,getter = isDataChanged) BOOL dataChanged;

@optional

-(void) vtDownlinkTaskDidLoadedFromCache:(id) data timestamp:(NSDate *) timestamp forTaskType:(Protocol *) taskType;

-(void) vtDownlinkTaskDidLoaded:(id) data forTaskType:(Protocol *) taskType;

-(void) vtDownlinkTaskDidFitalError:(NSError *) error forTaskType:(Protocol *) taskType;

@end
