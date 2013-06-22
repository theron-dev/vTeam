//
//  VTURLService.m
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTURLService.h"

#import "IVTURLDownlinkTask.h"
#import <vTeam/NSURL+QueryValue.h>

@interface VTURLServiceItem : NSObject

@property(nonatomic,assign) Protocol * taskType;
@property(nonatomic,retain) id task;
@property(nonatomic,retain) id httpTask;

@end

@implementation VTURLServiceItem

@synthesize taskType = _taskType;
@synthesize task = _task;
@synthesize httpTask = _httpTask;

-(void) dealloc{
    [_task release];
    [_httpTask release];
    [super dealloc];
}

@end

@interface VTURLService(){
    NSMutableArray * _items;
}

@end

@implementation VTURLService

-(void) dealloc{
    [_items release];
    [super dealloc];
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTURLDownlinkTask)){
        
        id<IVTURLDownlinkTask> urlTask = (id<IVTURLDownlinkTask>) task;
        
        if([urlTask vtDownlinkPageTaskPageIndex] == 1){
            [self vtDownlinkTaskDidLoadedFromCache:urlTask forTaskType:taskType];
        }
        
        NSString * url = [urlTask url];
        
        NSInteger offset = ( [urlTask vtDownlinkPageTaskPageIndex] - 1) * [urlTask vtDownlinkPageTaskPageSize];
        
        url = [url stringByReplacingOccurrencesOfString:@"{offset}" withString:[NSString stringWithFormat:@"%d",offset]];
        
        url = [url stringByReplacingOccurrencesOfString:@"{pageIndex}" withString:[NSString stringWithFormat:@"%d",[urlTask vtDownlinkPageTaskPageIndex]]];
        
        url = [url stringByReplacingOccurrencesOfString:@"{pageSize}" withString:[NSString stringWithFormat:@"%d",[urlTask vtDownlinkPageTaskPageSize]]];
        
        NSLog(@"%@",url);
        
        VTHttpTask * httpTask = [[VTHttpTask alloc] init];
        
        [httpTask setUserInfo:urlTask];
        [httpTask setSource:[task source]];
        [httpTask setResponseType:VTHttpTaskResponseTypeJSON];
        [httpTask setDelegate:self];
        [httpTask setRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120]];
        
        VTURLServiceItem * item = [[[VTURLServiceItem alloc] init] autorelease];
        
        item.taskType = taskType;
        item.task = urlTask;
        item.httpTask = httpTask;
        
        if(_items == nil){
            _items = [[NSMutableArray alloc] init];
        }
        
        [_items addObject:item];
        
        [self.context handle:@protocol(IVTHttpTask) task:httpTask priority:priority];
        
        [httpTask release];
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    if(taskType == @protocol(IVTURLDownlinkTask)){
        
        NSInteger c = [_items count];
        NSInteger i = 0;
        
        while(i < c){
            id item = [_items objectAtIndex:i];
            if([item task] == task){
                if([item httpTask]){
                    [[item httpTask] setDelegate:nil];
                    [self.context cancelHandle:@protocol(IVTHttpTask) task:[item httpTask]];
                }
                [_items removeObjectAtIndex:i];
                c --;
            }
            else{
                i ++;
            }
            
        }
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandleForSource:(id)source{
    
    NSInteger c = [_items count];
    NSInteger i = 0;
    
    while(i < c){
        id item = [_items objectAtIndex:i];
        if([[item task] source] == source){
            if([item httpTask]){
                [[item httpTask] setDelegate:nil];
                [self.context cancelHandle:@protocol(IVTHttpTask) task:[item httpTask]];
            }
            [_items removeObjectAtIndex:i];
            c --;
        }
        else{
            i ++;
        }
        
    }
    
    return NO;
}

-(NSString *) dataKey:(id<IVTDownlinkTask>)task forTaskType:(Protocol *)taskType{
    if(taskType == @protocol(IVTURLDownlinkTask)){
        return [[(id<IVTURLDownlinkTask>)task url] vtMD5String];
    }
    return [super dataKey:task forTaskType:taskType];
}

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error{
    
    id task = [httpTask userInfo];
    
    Protocol * taskType = nil;
    
    NSInteger c = [_items count];
    NSInteger i = 0;
    
    while(i < c){
        id item = [_items objectAtIndex:i];
        if([item httpTask] == httpTask){
            taskType = [item taskType];
            [_items removeObjectAtIndex:i];
            break;
        }
    }
    if(taskType && task){
        [self vtDownlinkTask:task didFitalError:error forTaskType:taskType];
    }
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    id task = [httpTask userInfo];
    
    Protocol * taskType = nil;
    
    NSInteger c = [_items count];
    NSInteger i = 0;
    
    while(i < c){
        id item = [_items objectAtIndex:i];
        if([item httpTask] == httpTask){
            taskType = [item taskType];
            [_items removeObjectAtIndex:i];
            break;
        }
    }
    
    NSLog(@"%@",[httpTask responseBody]);
    
    if(task && taskType){
        [self vtDownlinkTask:task didResponse:[httpTask responseBody] isCache:[task vtDownlinkPageTaskPageIndex] == 1 forTaskType:taskType];
    }
}

@end