//
//  VTUplinkService.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTUplinkService.h"

#import <vTeam/VTAPITask.h>


@implementation VTUplinkService

-(void) vtUplinkTask:(id<IVTUplinkTask>) uplinkTask didSuccessResults:(id) data forTaskType:(Protocol *) taskType{
    
    if([(id)uplinkTask.delegate respondsToSelector:@selector(vtUploadTask:didSuccessResults:forTaskType:)]){
        [uplinkTask.delegate vtUploadTask:uplinkTask didSuccessResults:data forTaskType:taskType];
    }
}

-(void) vtUplinkTask:(id<IVTUplinkTask>) uplinkTask didFailWithError:(NSError *) error forTaskType:(Protocol *) taskType{
    
    if([(id)uplinkTask.delegate respondsToSelector:@selector(vtUploadTask:didFailWithError:forTaskType:)]){
        [uplinkTask.delegate vtUploadTask:uplinkTask didFailWithError:error forTaskType:taskType];
    }
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    VTAPITask * t = [[VTAPITask alloc] init];
    
    [t setTaskType:taskType];
    [t setTask:task];
    
    [self.context cancelHandle:@protocol(IVTAPICancelTask) task:t];
    
    [t release];
    
    return YES;
}


@end
