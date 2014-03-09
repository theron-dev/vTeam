//
//  VTAppService.m
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTAppService.h"

#import "VTAppVersionTask.h"

#import "VTAPIRequestTask.h"
#import "VTAPIResponseTask.h"

#import "NSObject+VTValue.h"

@interface VTAppService()

@end

@implementation VTAppService



-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    
    if(@protocol(IVTAppVersionTask) == taskType){
        
        VTAPIRequestTask * httpTask = [[VTAPIRequestTask alloc] init];
        
        [httpTask setSource:[task source]];
        [httpTask setTaskType:taskType];
        [httpTask setTask:task];
        [httpTask setApiKey:@"app-version"];
        
        NSMutableDictionary * queryValues = [NSMutableDictionary dictionaryWithCapacity:4];
        
        NSBundle * bundle = [NSBundle mainBundle];
        
        [queryValues setValue:[[bundle infoDictionary] valueForKey:@"CFBundleShortVersionString"] forKey:@"app-version"];
        [queryValues setValue:@"1" forKey:@"app-platform"];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        id did = [userDefaults valueForKey:@"device-did"];
        
        if(did){
            [queryValues setValue:[NSString stringWithFormat:@"%@", did] forKey:@"device-did"];
        }
        
        id uid = [self.context uid];
        
        if(uid){
            [queryValues setValue:[NSString stringWithFormat:@"%@", uid] forKey:@"auth-uid"];
        }
        
        id token = [self.context token];
        
        if(token){
            [queryValues setValue:[NSString stringWithFormat:@"%@", token] forKey:@"auth-token"];
        }
    
        
        [httpTask setQueryValues:queryValues];
        
        [self.context handle:@protocol(IVTAPIRequestTask) task:httpTask priority:0];
        
        [httpTask release];
        
        return YES;
    }
    else if(taskType == @protocol(IVTAPIResponseTask)){
        
        id<IVTAPIResponseTask> respTask = (id<IVTAPIResponseTask>) task;
        
        if([respTask taskType] == @protocol(IVTAppVersionTask)){
            
            id<IVTAppVersionTask> versionTask = (id<IVTAppVersionTask>) [respTask task];
            
            if([respTask error]){
                
                NSLog(@"%@",[respTask error]);
                
                [self vtUplinkTask:[respTask task] didFailWithError:[respTask error] forTaskType:[respTask taskType]];
            }
            else{
                
                NSLog(@"%@",[respTask resultsData]);
                
                [versionTask setLevel: [[respTask resultsData] intValueForKey:@"app-level"]];
                [versionTask setContent:[[respTask resultsData] stringValueForKey:@"app-content"]];
                [versionTask setUri:[[respTask resultsData] stringValueForKey:@"app-uri"]];
                [versionTask setVersion:[[respTask resultsData] stringValueForKey:@"app-version"]];
                
                [self vtUplinkTask:[respTask task] didSuccessResults:[respTask resultsData]
                       forTaskType:[respTask taskType]];
            }
            
            return YES;
        }
        
    }
    return NO;
}


@end
