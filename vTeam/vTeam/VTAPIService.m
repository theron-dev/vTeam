//
//  VTAPIService.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTAPIService.h"

#import <vTeam/NSURL+QueryValue.h>

@interface VTAPIService(){
    NSMutableArray * _requests;
}

@end

@implementation VTAPIService

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTAPIRequestTask)){
        
        id<IVTAPIRequestTask> reqTask = (id<IVTAPIRequestTask>) task;
        
        NSString * apiKey = [reqTask apiKey];
        
        NSString * url = [reqTask apiUrl];
        
        if(url == nil){
            url = [self.config valueForKeyPath:apiKey];
        }
        
        NSURL * u = [NSURL URLWithString:url queryValues:[reqTask queryValues]];
        
        NSLog(@"%@",u);
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:u cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[[self.config valueForKey:@"timeout"] doubleValue]];
        
        VTHttpFormBody * body = [reqTask body];
        
        if(body){
            [request setHTTPMethod:@"POST"];
            [request setValue:[body contentType] forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[body bytesBody]];
        }
        
        VTHttpTask * httpTask = [[VTHttpTask alloc] init];
        
        [httpTask setRequest:request];
        [httpTask setUserInfo:reqTask];
        [httpTask setSource:[task source]];
        [httpTask setResponseType:VTHttpTaskResponseTypeJSON];
        [httpTask setDelegate:self];
        
        [reqTask setHttpTask:httpTask];
        
        if(_requests == nil){
            _requests = [[NSMutableArray alloc] init];
        }
        
        [_requests addObject:reqTask];
        
        [self.context handle:@protocol(IVTHttpAPITask) task:httpTask priority:priority];
        
        
        [httpTask release];
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    if(taskType == @protocol(IVTAPIRequestTask)){
        
        NSInteger c = [_requests count];
        NSInteger i = 0;
        
        while(i < c){
            id request = [_requests objectAtIndex:i];
            if(request == task){
                if([request httpTask]){
                    [self.context cancelHandle:@protocol(IVTHttpAPITask) task:[request httpTask]];
                }
                [_requests removeObjectAtIndex:i];
                c --;
            }
            else{
                i ++;
            }
            
        }
        
        return YES;
    }
    
    if(taskType == @protocol(IVTAPICancelTask)){
        
        NSInteger c = [_requests count];
        NSInteger i = 0;
        
        while(i < c){
            id request = [_requests objectAtIndex:i];
            if([request task] == [(id)task task] && [request taskType] == [(id)task taskType]){
                if([request httpTask]){
                    [self.context cancelHandle:@protocol(IVTHttpAPITask) task:[request httpTask]];
                }
                [_requests removeObjectAtIndex:i];
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
    
    NSInteger c = [_requests count];
    NSInteger i = 0;
    
    while(i < c){
        id request = [_requests objectAtIndex:i];
        if([request source] == source){
            if([request httpTask]){
                [self.context cancelHandle:@protocol(IVTHttpAPITask) task:[request httpTask]];
            }
            [_requests removeObjectAtIndex:i];
            c --;
        }
        else{
            i ++;
        }

    }

    return NO;
}

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error{
    
    id task = [httpTask userInfo];
    [_requests removeObject:task];
    
    VTAPIResponseTask * respTask =[[VTAPIResponseTask alloc] init];
    [respTask setTask:[task task]];
    [respTask setTaskType:[task taskType]];
    [respTask setUserInfo:[task userInfo]];
    [respTask setError:error];
    
    [self.context handle:@protocol(IVTAPIResponseTask) task:respTask priority:0];
    
    [respTask release];
    
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    id task = [httpTask userInfo];
    [_requests removeObject:task];
    
    VTAPIResponseTask * respTask =[[VTAPIResponseTask alloc] init];
    [respTask setTask:[task task]];
    [respTask setTaskType:[task taskType]];
    [respTask setUserInfo:[task userInfo]];
    [respTask setResultsData:[httpTask responseBody]];
    
    [self.context handle:@protocol(IVTAPIResponseTask) task:respTask priority:0];
    
    [respTask release];
}


@end
