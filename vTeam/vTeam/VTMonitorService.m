//
//  VTMonitorService.m
//  vTeam
//
//  Created by zhang hailong on 13-7-19.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMonitorService.h"


@interface VTMonitorObject : VTDBObject

@property(nonatomic,retain) NSString * taskType;
@property(nonatomic,retain) NSString * taskClass;
@property(nonatomic,assign) double runTime;

@end

@implementation VTMonitorObject

@synthesize taskType = _taskType;
@synthesize taskClass = _taskClass;
@synthesize runTime = _runTime;

-(void) dealloc{
    [_taskType release];
    [_taskClass release];
    [super dealloc];
}

@end

@interface VTMonitorService(){

}

@property(nonatomic,readonly) VTDBContext * dbContext;

@end

@implementation VTMonitorService

@synthesize dbContext = _dbContext;

-(void) dealloc{
    [_dbContext release];
    [super dealloc];
}

-(VTDBContext *) dbContext{
    
    if(_dbContext == nil){
        
        VTSqlite * db = [[VTSqlite alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/monitor.db"]];
        _dbContext = [[VTDBContext alloc] init];
        [_dbContext setDb:db];
        [db release];
        
        [_dbContext regDBObjectClass:[VTMonitorObject class]];
        
    }
    
    return _dbContext;
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    NSTimeInterval t = CFAbsoluteTimeGetCurrent();

    dispatch_async(dispatch_get_current_queue(), ^{
       
        VTMonitorObject * dataObject = [[VTMonitorObject alloc] init];
        
        [dataObject setRunTime:CFAbsoluteTimeGetCurrent() - t];
        [dataObject setTaskType:NSStringFromProtocol(taskType)];
        [dataObject setTaskClass:NSStringFromClass([task class])];
        
        [self.dbContext insertObject:dataObject];
        
        [dataObject release];
        
    });
    
    return NO;
}


@end
