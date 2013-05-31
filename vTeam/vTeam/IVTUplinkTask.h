//
//  IVTUplinkTask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTTask.h>

@protocol IVTUplinkTask <IVTTask>

@property(nonatomic,assign) IBOutlet id delegate;

@end

@protocol IVTUplinkTaskDelegate


@optional

-(void) vtUploadTask:(id<IVTUplinkTask>) uplinkTask didSuccessResults:(id) results forTaskType:(Protocol *) taskType;

-(void) vtUploadTask:(id<IVTUplinkTask>) uplinkTask didFailWithError:(NSError *)error forTaskType:(Protocol *)taskType;

@end
