//
//  VTBehaviorService.m
//  vTeam
//
//  Created by zhang hailong on 13-8-1.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBehaviorService.h"

#import "VTBehaviorTask.h"
#import "VTBehaviorTransactionTask.h"

@interface VTBehaviorService(){

}

@property(readonly) VTDBContext * dbContext;
@property(readonly) dispatch_queue_t dispatchQueue;

@end

@implementation VTBehaviorService

@synthesize dbContext = _dbContext;
@synthesize dispatchQueue = _dispatchQueue;

-(void) dealloc{
    if(_dispatchQueue){
        dispatch_release(_dispatchQueue);
    }
    [_dbContext release];
    [super dealloc];
}

-(VTDBContext *) dbContext{
    
    if(_dbContext == nil){
        
        VTSqlite * db = [[VTSqlite alloc] initWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/behavior.db"]];
        _dbContext = [[VTDBContext alloc] init];
        [_dbContext setDb:db];
        
        NSArray * items = [self.config valueForKey:@"db"];
        
        if([items isKindOfClass:[NSArray class]]){
            for(id item in items){
                Class tableClass = NSClassFromString(item);
                if([tableClass isSubclassOfClass:[VTDBObject class]]){
                    [_dbContext regDBObjectClass:tableClass];
                }
            }
        }
        
        [db release];

    }
    
    return _dbContext;
}

-(dispatch_queue_t) dispatchQueue{
    if(_dispatchQueue == nil){
        _dispatchQueue = dispatch_queue_create("org.hailong.vteam.behavior", NULL);
    }
    return _dispatchQueue;
}


-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTBehaviorTask)){
        
        id<IVTBehaviorTask> behaviorTask = (id<IVTBehaviorTask>) task;
        
        VTBehaviorObject * dataObject = [behaviorTask dataObject];
        
        if(dataObject){
            
            dataObject.timestamp = [[NSDate date] timeIntervalSince1970];
            
            dispatch_async(self.dispatchQueue, ^{
                if([dataObject rowid]){
                    [self.dbContext updateObject:dataObject];
                }
                else{
                    [self.dbContext insertObject:dataObject];
                }
            });
            
        }

        return YES;
    }

    if(taskType == @protocol(IVTBehaviorTransactionTask)){
        
        __strong id<IVTBehaviorTransactionTask> behaviorTask = (id<IVTBehaviorTransactionTask>) task;
        
        dispatch_async(self.dispatchQueue, ^{
            [behaviorTask onBehaviorDBContext:self.dbContext];
        });
        
        return YES;
    }
 
    return NO;
}



@end
