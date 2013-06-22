//
//  VTDownlinkService.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDownlinkService.h"

#import <vTeam/VTAPITask.h>

#import "VTDBContext.h"
#import "VTDBObject.h"

static VTDBContext * gDownlinkServiceDBContext = nil;

@interface VTDownlinkServiceDBObject : VTDBObject

@property(nonatomic,retain) NSString * service;
@property(nonatomic,retain) NSString * key;
@property(nonatomic,retain) id data;
@property(nonatomic,assign) NSInteger timestamp;

@end

@implementation VTDownlinkServiceDBObject

@synthesize service = _service;
@synthesize key = _key;
@synthesize data = _data;
@synthesize timestamp = _timestamp;

-(void) dealloc{
    [_service release];
    [_key release];
    [_data release];
    [super dealloc];
}

@end

@interface VTDownlinkService(){
    NSMutableDictionary * _dataObjects;
}

@end

@implementation VTDownlinkService

+(id) dbContext {

    if(gDownlinkServiceDBContext == nil){
        
        NSString * dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Caches"];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        gDownlinkServiceDBContext = [[VTDBContext alloc] init];
        VTSqlite * db = [[VTSqlite alloc] initWithPath:[dbPath stringByAppendingPathComponent:@"VTDownlinkService.db"]];
        [gDownlinkServiceDBContext setDb:db];
        [db release];
        
        [gDownlinkServiceDBContext regDBObjectClass:[VTDownlinkServiceDBObject class]];
    }
    
    return gDownlinkServiceDBContext;
}

-(void) dealloc{
    [_dataObjects release];
    [super dealloc];
}

-(id) dataObjectForKey:(NSString *) key{
    id dataObject = [_dataObjects objectForKey:key];
    if(dataObject == nil){
        id<IVTSqliteCursor> cursor = [[VTDownlinkService dbContext] query:[VTDownlinkServiceDBObject class] sql:@" WHERE [service]=:service AND [key]=:key" data:[NSDictionary dictionaryWithObjectsAndKeys:NSStringFromClass([self class]),@"service",key,@"key", nil]];
        if([cursor next]){
            dataObject = [[[VTDownlinkServiceDBObject alloc] init] autorelease];
            [cursor toDataObject:dataObject];
            if(_dataObjects == nil){
                _dataObjects = [[NSMutableDictionary alloc] init];
            }
            [_dataObjects setObject:dataObject forKey:key];
        }
        [cursor close];
    }
    return dataObject;
}

-(id) dataObjectForKey:(NSString *) key setData:(id) data{
    id dataObject = [self dataObjectForKey:key];
    if(dataObject == nil){
        dataObject = [[[VTDownlinkServiceDBObject alloc] init] autorelease];
        [dataObject setValue:NSStringFromClass([self class]) forKey:@"service"];
        [dataObject setValue:key forKey:@"key"];
        [dataObject setValue:data forKey:@"data"];
        [dataObject setValue:[NSNumber numberWithInt:time(NULL)] forKey:@"timestamp"];
        [[VTDownlinkService dbContext] insertObject:dataObject];
        if(_dataObjects == nil){
            _dataObjects = [[NSMutableDictionary alloc] init];
        }
        [_dataObjects setObject:dataObject forKey:key];
    }
    else{
        [dataObject setValue:[NSNumber numberWithInt:time(NULL)] forKey:@"timestamp"];
        [[VTDownlinkService dbContext] updateObject:dataObject];
    }
    return dataObject;
}

-(NSString *) dataKey:(id<IVTDownlinkTask>) task forTaskType:(Protocol *) taskType{
    return NSStringFromProtocol(taskType);
}


-(void) vtDownlinkTaskDidLoadedFromCache:(id<IVTDownlinkTask>) downlinkTask forTaskType:(Protocol *) taskType{
    NSString * dataKey = [self dataKey:downlinkTask forTaskType:taskType];
    id dataObject = [self dataObjectForKey:dataKey];
    if(dataObject && [downlinkTask respondsToSelector:@selector(vtDownlinkTaskDidLoadedFromCache:timestamp:forTaskType:)]){
        [downlinkTask vtDownlinkTaskDidLoadedFromCache:[dataObject valueForKey:@"data"] timestamp:[NSDate dateWithTimeIntervalSince1970:[[dataObject valueForKey:@"timestamp"] intValue]] forTaskType:taskType];
    };
}

-(void) vtDownlinkTask:(id<IVTDownlinkTask>) downlinkTask didResponse:(id) data isCache:(BOOL) isCache forTaskType:(Protocol *) taskType{
    
    if(isCache){
        NSString * dataKey = [self dataKey:downlinkTask forTaskType:taskType];
        [self dataObjectForKey:dataKey setData:data];
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
    [_dataObjects release];
    _dataObjects = nil;
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
