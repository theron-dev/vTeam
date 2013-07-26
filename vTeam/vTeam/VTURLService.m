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
        
        if(url == nil){
            url = [self.config valueForKey:[urlTask urlKey]];
        }
        
        NSInteger offset = ( [urlTask vtDownlinkPageTaskPageIndex] - 1) * [urlTask vtDownlinkPageTaskPageSize];
        
        url = [url stringByReplacingOccurrencesOfString:@"{offset}" withString:[NSString stringWithFormat:@"%d",offset]];
        
        url = [url stringByReplacingOccurrencesOfString:@"{pageIndex}" withString:[NSString stringWithFormat:@"%d",[urlTask vtDownlinkPageTaskPageIndex]]];
        
        url = [url stringByReplacingOccurrencesOfString:@"{pageSize}" withString:[NSString stringWithFormat:@"%d",[urlTask vtDownlinkPageTaskPageSize]]];
        
        url = [url stringByDataOutlet:urlTask];
        
        VTHttpTask * httpTask = nil;
        
        Class httpClass = [urlTask httpClass];
        
        if(httpClass == nil){
            httpTask = [[VTHttpTask alloc] init];
            [httpTask setResponseType:VTHttpTaskResponseTypeJSON];
        }
        else{
            httpTask = [[httpClass alloc] init];
        }

        [httpTask setUserInfo:urlTask];
        [httpTask setSource:[task source]];
        [httpTask setDelegate:self];
        [httpTask setRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url queryValues:[urlTask queryValues]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120]];
        
        NSLog(@"%@",httpTask.request);
        
        VTURLServiceItem * item = [[[VTURLServiceItem alloc] init] autorelease];
        
        item.taskType = taskType;
        item.task = urlTask;
        item.httpTask = httpTask;
        
        if(_items == nil){
            _items = [[NSMutableArray alloc] init];
        }
        
        [_items addObject:item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.context handle:@protocol(IVTHttpAPITask) task:httpTask priority:priority];
        });
        
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
        
        NSString * url = [(id<IVTURLDownlinkTask>)task url];
        
        if(url == nil){
            url = [self.config valueForKey:[(id<IVTURLDownlinkTask>)task urlKey]];
        }
        
        url = [url stringByDataOutlet:task];

        url = [[NSURL URLWithString:url queryValues:[(id<IVTURLDownlinkTask>)task queryValues]] absoluteString];
        
        return [url vtMD5String];
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
        i ++;
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
        i ++;
    }
    
    NSLog(@"%@",[httpTask responseBody]);
    
    if(task && taskType){
        NSError * error = [self errorByResponseBody:[httpTask responseBody] task:task];
        if(error == nil){
            [self vtDownlinkTask:task didResponse:[httpTask responseBody] isCache:[task vtDownlinkPageTaskPageIndex] == 1 forTaskType:taskType];
        }
        else{
            [self vtDownlinkTask:task didFitalError:error forTaskType:taskType];
        }
    }
}

-(NSError *) errorByResponseBody:(id) body task:(id) task{
    NSString * errorCodeKeyPath = [task errorCodeKeyPath];
    NSString * errorKeyPath = [task errorKeyPath];
    if(errorCodeKeyPath){
        int errorCode = [[body dataForKeyPath:errorCodeKeyPath] intValue];
        
        if(errorCode ==0){
            return nil;
        }
        NSString * error = [body dataForKeyPath:errorKeyPath];
        
        if(error == nil){
            error = @"";
        }
        
        return [NSError errorWithDomain:@"VTURLService" code:errorCode
                               userInfo:[NSDictionary dictionaryWithObject:error forKey:NSLocalizedDescriptionKey]];
    }
    return nil;
}

@end