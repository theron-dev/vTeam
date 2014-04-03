//
//  VTGatherService.m
//  vTeam
//
//  Created by zhang hailong on 14-4-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTGatherService.h"

#import "VTGatherTask.h"

@interface VTGatherService(){
    NSMutableArray * _runnables;
}

-(void) removeRunnable:(id) runnable;

@end

@interface VTGatherServiceRunnable : NSObject<IVTUplinkTaskDelegate>

@property(nonatomic,assign) VTGatherService * gatherService;
@property(nonatomic,readonly) id<IVTServiceContext> context;
@property(nonatomic,readonly,retain) id<IVTGatherTask> gatherTask;
@property(nonatomic,assign) NSInteger loadingCount;
@property(nonatomic,assign) NSInteger finishCount;
@property(nonatomic,assign) Protocol * taskType;

@end

@implementation VTGatherServiceRunnable

@synthesize gatherTask = _gatherTask;

-(void) dealloc{
    
    for (id task in [_gatherTask tasks]) {
        [task setDelegate:nil];
    }
    
    [_gatherTask release];
    
    [super dealloc];
}

-(id) initWithGatherTask:(id<IVTGatherTask>) gatherTask context:(id<IVTServiceContext>) context{
    
    if((self = [super init])){
        
        if([[gatherTask taskTypes] count]){
            
            _gatherTask = [gatherTask retain];
            _context = context;
            
            NSArray * tasks = [_gatherTask tasks];
            NSArray * taskTypes = [_gatherTask taskTypes];
            
            for (id task in tasks) {
                
                [task setDelegate:self];
                
                [_context handle:[[taskTypes objectAtIndex:_loadingCount] pointerValue] task:task priority:0];
                
                _loadingCount ++;
            }
            
        }
        else {
            [self release];
            return nil;
        }
    }
    
    return self;
}


-(void) vtUploadTask:(id<IVTUplinkTask>) uplinkTask didSuccessResults:(id) results forTaskType:(Protocol *) taskType{
    
    if(_finishCount < _loadingCount){
        
        _finishCount ++ ;
        
        if(_finishCount == _loadingCount){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id delegate = [_gatherTask delegate];
                
                if([delegate respondsToSelector:@selector(vtUploadTask:didSuccessResults:forTaskType:)]){
                    [delegate vtUploadTask:_gatherTask didSuccessResults:results forTaskType:_taskType];
                }
                
                [_gatherService removeRunnable:self];
                
            });
            
        }
    }
    
}

-(void) vtUploadTask:(id<IVTUplinkTask>) uplinkTask didFailWithError:(NSError *)error forTaskType:(Protocol *)taskType{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSInteger index = 0;
        
        NSArray * tasks = [_gatherTask tasks];
        NSArray * taskTypes = [_gatherTask taskTypes];
        
        for (id task in tasks) {
            
            [task setDelegate:nil];
            
            [_context cancelHandle:[[taskTypes objectAtIndex:index] pointerValue] task:task];
            
            index ++;
        }

        id delegate = [_gatherTask delegate];
        
        if([delegate respondsToSelector:@selector(vtUploadTask:didFailWithError:forTaskType:)]){
            [delegate vtUploadTask:_gatherTask didFailWithError:error forTaskType:_taskType];
        }
        
        [_gatherService removeRunnable:self];
        
    });
}

@end



@implementation VTGatherService

-(void) dealloc{
    
    for (VTGatherServiceRunnable * runnable in _runnables) {
        [runnable setGatherService:nil];
    }
    
    [_runnables release];
    [super dealloc];
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(@protocol(IVTGatherTask) == taskType){
        
        id<IVTGatherTask> gatherTask = (id<IVTGatherTask>) task;
        
        id runnable = [[VTGatherServiceRunnable alloc] initWithGatherTask:gatherTask context:self.context];
        
        if(runnable){
            
            if(_runnables == nil){
                _runnables = [[NSMutableArray alloc] initWithCapacity:4];
            }
            
            [_runnables addObject:runnable];
            [runnable setTaskType:taskType];
            [runnable setGatherService:self];
        }
        
        return YES;
    }
    
    return NO;
}

-(void) removeRunnable:(id) runnable{
    [runnable setGatherService:nil];
    [_runnables removeObject:runnable];
}

@end
