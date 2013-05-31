//
//  VTDownlinkService.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDownlinkService.h"

#import <vTeam/VTAPITask.h>

@interface VTDownlinkService(){
    NSMutableDictionary * _cached;
}

@end

@implementation VTDownlinkService

-(NSMutableDictionary *) cached{
    if(_cached == nil){
        
        NSString * filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:NSStringFromClass([self class])] stringByAppendingPathExtension:@"plist"];
        
        NSData * data = [[NSData alloc] initWithContentsOfFile:filePath];
        
        NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
        
        _cached = [[NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:nil] retain];
        
        [data release];
        
        if(_cached == nil){
            _cached = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
    }
    return _cached;
}

-(NSString *) cacheValueKey:(id<IVTDownlinkTask>) task forTaskType:(Protocol *) taskType{
    return NSStringFromProtocol(taskType);
}

-(void) vtDownlinkTaskDidLoadedFromCache:(id<IVTDownlinkTask>) downlinkTask forTaskType:(Protocol *) taskType{
    NSString * key = [self cacheValueKey:downlinkTask forTaskType:taskType];
    id data = [[self cached] valueForKey:key];
    if(data && [downlinkTask respondsToSelector:@selector(vtDownlinkTaskDidLoadedFromCache:timestamp:forTaskType:)]){
        [downlinkTask vtDownlinkTaskDidLoadedFromCache:data timestamp:[[self cached] valueForKey:[key stringByAppendingString:@"-timestamp"]] forTaskType:taskType];
    }
}

-(void) vtDownlinkTask:(id<IVTDownlinkTask>) downlinkTask didResponse:(id) data isCache:(BOOL) isCache forTaskType:(Protocol *) taskType{
    
    if(isCache){
        NSString * key = [self cacheValueKey:downlinkTask forTaskType:taskType];
        [[self cached] setValue:data forKey:key];
        [[self cached] setValue:[NSDate date] forKey:[key stringByAppendingString:@"-timestamp"]];
    }
    
    if([downlinkTask respondsToSelector:@selector(vtDownlinkTaskDidLoaded:forTaskType:)]){
        [downlinkTask vtDownlinkTaskDidLoaded:data forTaskType:taskType];
    }
    
}

-(void) vtDownlinkTask:(id<IVTDownlinkTask>) downlinkTask didFitalError:(NSError *) error forTaskType:(Protocol *) taskType{
    if([downlinkTask respondsToSelector:@selector(vtDownlinkTaskDidFitalError:forTaskType:)]){
        [downlinkTask vtDownlinkTaskDidFitalError:error forTaskType:taskType];
    }
}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if(_cached ){
        NSString * filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:NSStringFromClass([self class])] stringByAppendingPathExtension:@"plist"];
        [[NSPropertyListSerialization dataFromPropertyList:_cached format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil] writeToFile:filePath atomically:YES];
        [_cached release];
        _cached = nil;
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
