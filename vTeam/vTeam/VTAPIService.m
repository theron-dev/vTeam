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
    NSMutableArray * _httpTasks;
    NSMutableArray * _responses;
}

@end

@implementation VTAPIService

-(void) dealloc{
    [_httpTasks release];
    [_responses release];
    [super dealloc];
}
-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTAPIRequestTask)){
        
        id<IVTAPIRequestTask> reqTask = (id<IVTAPIRequestTask>) task;
        
        
        VTHttpTask * httpTask = [[VTHttpTask alloc] init];
        
        [httpTask setUserInfo:reqTask];
        [httpTask setSource:[reqTask source]];
        [httpTask setResponseType:VTHttpTaskResponseTypeJSON];
        [httpTask setDelegate:self];
        
        if(_httpTasks == nil){
            _httpTasks = [[NSMutableArray alloc] init];
        }
        
        [_httpTasks addObject:httpTask];
        
        [self.context handle:@protocol(IVTHttpAPITask) task:httpTask priority:priority];
        
        
        [httpTask release];
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    if(taskType == @protocol(IVTAPIRequestTask)){
        
        NSInteger c = [_httpTasks count];
        NSInteger i = 0;
        
        while(i < c){
            VTHttpTask * httpTask = [_httpTasks objectAtIndex:i];
            if([httpTask userInfo] == task){
                [self.context cancelHandle:@protocol(IVTHttpAPITask) task:httpTask];
                [_httpTasks removeObjectAtIndex:i];
                c --;
            }
            else{
                i ++;
            }
            
        }
        
        c = [_responses count];
        i = 0;
        
        while(i < c){
            id resp = [_responses objectAtIndex:i];
            if([resp task] == [(id)task task]){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendResponseTask:) object:resp];
                [_responses removeObjectAtIndex:i];
                c --;
            }
            else{
                i ++;
            }
            
        }
        
        return YES;
    }
    
    if(taskType == @protocol(IVTAPICancelTask)){
        
        NSInteger c = [_httpTasks count];
        NSInteger i = 0;
        
        while(i < c){
            VTHttpTask * httpTask = [_httpTasks objectAtIndex:i];
            id<IVTAPIRequestTask> reqTask = [httpTask userInfo];
            if([reqTask task] == [(id)task task] && [reqTask taskType] == [(id)task taskType]){
                [self.context cancelHandle:@protocol(IVTHttpAPITask) task:httpTask];
                [_httpTasks removeObjectAtIndex:i];
                c --;
            }
            else{
                i ++;
            }
            
        }
        
        c = [_responses count];
        i = 0;
        
        while(i < c){
            id resp = [_responses objectAtIndex:i];
            if([resp task] == [(id)task task] && [resp taskType] == [(id)task taskType]){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendResponseTask:) object:resp];
                [_responses removeObjectAtIndex:i];
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
    
    NSInteger c = [_httpTasks count];
    NSInteger i = 0;
    
    while(i < c){
        VTHttpTask * httpTask = [_httpTasks objectAtIndex:i];
        if([httpTask source] == source){
            [self.context cancelHandle:@protocol(IVTHttpAPITask) task:httpTask];
            [_httpTasks removeObjectAtIndex:i];
            c --;
        }
        else{
            i ++;
        }

    }
    
    c = [_responses count];
    i = 0;
    
    while(i < c){
        id resp = [_responses objectAtIndex:i];
        if([resp source] == source){
            [_responses removeObjectAtIndex:i];
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
    
    [_httpTasks removeObject:httpTask];
    
    VTAPIResponseTask * respTask =[[VTAPIResponseTask alloc] init];
    [respTask setTask:[task task]];
    [respTask setTaskType:[task taskType]];
    [respTask setUserInfo:[task userInfo]];
    [respTask setError:error];
    [respTask setUrl:[[(VTHttpTask *)httpTask request] URL]];
    [respTask setSource:[task source]];
    
    [self.context handle:@protocol(IVTAPIResponseTask) task:respTask priority:0];
    
    [respTask release];
    
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    NSLog(@"%@",[httpTask request]);
    NSLog(@"%@",(NSHTTPURLResponse *)[httpTask response]);
    
    id task = [httpTask userInfo];
    [_httpTasks removeObject:httpTask];
    
    VTAPIResponseTask * respTask =[[VTAPIResponseTask alloc] init];
    [respTask setTask:[task task]];
    [respTask setSource:[task source]];
    [respTask setTaskType:[task taskType]];
    [respTask setUserInfo:[task userInfo]];
    [respTask setResultsData:[httpTask responseBody]];
    [respTask setUrl:[[(VTHttpTask *)httpTask request] URL]];
    [respTask setStatusCode:[(NSHTTPURLResponse *)[httpTask response] statusCode]];
    [respTask setResponseUUID:[httpTask responseUUID]];
    
    if(_responses == nil){
        _responses = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    [_responses addObject:respTask];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSUInteger index = [_responses indexOfObject:respTask];
        
        if(index != NSNotFound){
            
            [[respTask retain] autorelease];
            
            [_responses removeObjectAtIndex:index];
            
            [self.context handle:@protocol(IVTAPIResponseTask) task:respTask priority:0];
            
        }
    });
  
    [respTask release];
}

-(void) vtHttpTaskWillRequest:(id)httpTask{
    
    id reqTask = [httpTask userInfo];
    
    [self.context handle:@protocol(IVTAPIWillRequestTask) task:reqTask priority:0];
    
    NSString * apiKey = [reqTask apiKey];
    
    NSString * url = [reqTask apiUrl];
    
    if(url == nil){
        url = [self.config valueForKeyPath:apiKey];
    }
    
    NSURL * u = [NSURL URLWithString:url queryValues:[reqTask queryValues]];
    
    NSLog(@"%@",u);
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:u cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[[self.config valueForKey:@"timeout"] doubleValue]];
    
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSDictionary * httpHeaders = [reqTask httpHeaders];
    
    for (NSString * key in httpHeaders) {
        [request setValue:[httpHeaders valueForKey:key] forHTTPHeaderField:key];
    }
    
    if([reqTask httpMethod]){
        [request setHTTPMethod:[reqTask httpMethod]];
    }
    
    VTHttpFormBody * body = [reqTask body];
    
    if(body){
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[body bytesBody]];
        [request setValue:[body contentType] forHTTPHeaderField:@"Content-Type"];
    }
    
    [httpTask setRequest:request];
}

@end
