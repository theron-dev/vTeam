//
//  VTUplinkService.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTUplinkService.h"

#import <vTeam/VTAPITask.h>

#import "VTAPIResponseTask.h"

#import <objc/runtime.h>

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


-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTAPIResponseTask)){
        
        id<IVTAPIResponseTask> respTask = (id<IVTAPIResponseTask>) task;
        
        NSString * name = NSStringFromProtocol([respTask taskType]);
        
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"handle%@:task:response:",name]);
        
        Method method = class_getInstanceMethod([self class], sel);
        
        if(method){
            
            IMP impl = method_getImplementation(method);
            
            return (* ((BOOL (*) (id sender,SEL name,Protocol * taskType,id task,id response)) impl) ) (self,sel,[respTask taskType],[respTask task],respTask);
        }
        
    }
    else {
        
        NSString * name = NSStringFromProtocol(taskType);
        
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"handle%@:task:priority:",name]);
      
        Method method = class_getInstanceMethod([self class], sel);
        
        if(method){
            
            IMP impl = method_getImplementation(method);
            
            return (* ((BOOL (*) (id sender,SEL name,Protocol * taskType,id task,NSInteger priority)) impl) ) (self,sel,taskType,task,priority);
        }

    }
    
    return NO;
}


@end
