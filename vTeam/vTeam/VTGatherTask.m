//
//  VTGatherTask.m
//  vTeam
//
//  Created by zhang hailong on 14-4-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTGatherTask.h"


@implementation VTGatherTask

@synthesize taskType = _taskType;
@synthesize task = _task;
@synthesize taskTypes = _taskTypes;
@synthesize tasks = _tasks;

-(void) dealloc{
    [_task release];
    [_tasks release];
    [_taskTypes release];
    [super dealloc];
}

-(void) addTask:(id)task taskType:(Protocol *)taskType{
    
    if(task && taskType){
        
        if(_taskTypes == nil){
            _taskTypes = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        if(_tasks == nil){
            _tasks = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        [(NSMutableArray *) _taskTypes addObject:[NSValue valueWithPointer:taskType]];
        [(NSMutableArray *) _tasks addObject:task];
        
        [task setSource:self.source];
        [task setDelegate:self];
    }
    
}

@end
