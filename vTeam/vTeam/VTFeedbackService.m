//
//  VTFeedbackService.m
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTFeedbackService.h"

#import "VTFeedbackTask.h"

#import "VTAPIRequestTask.h"
#import "VTAPIResponseTask.h"

#import <UIKit/UIKit.h>

#import "UIDevice+VTUUID.h"

@implementation VTFeedbackService


-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    
    if(@protocol(IVTFeedbackTask) == taskType){
        
        id<IVTFeedbackTask> feedbackTask = (id<IVTFeedbackTask>) task;
        
        VTAPIRequestTask * httpTask = [[VTAPIRequestTask alloc] init];
        
        [httpTask setSource:[feedbackTask source]];
        [httpTask setTaskType:taskType];
        [httpTask setTask:task];
        [httpTask setApiKey:@"feedback"];
        
        VTHttpFormBody * body = [[VTHttpFormBody alloc] init];
        
        [httpTask setBody:body];
        
        NSBundle * bundle = [NSBundle mainBundle];
        
        [body addItemValue:[bundle bundleIdentifier] forKey:@"identifier"];
        [body addItemValue:[[bundle infoDictionary] valueForKey:@"CFBundleShortVersionString"] forKey:@"version"];
        [body addItemValue:[[bundle infoDictionary] valueForKey:@"CFBundleVersion"] forKey:@"build"];
        
        UIDevice * device = [UIDevice currentDevice];
        
        [body addItemValue:[device name] forKey:@"deviceName"];
        [body addItemValue:[device systemName] forKey:@"systemName"];
        [body addItemValue:[device systemVersion] forKey:@"systemVersion"];
        [body addItemValue:[device model] forKey:@"model"];
        [body addItemValue:[device vtUniqueIdentifier] forKey:@"deviceIdentifier"];
    
        [body addItemValue:[feedbackTask body] forKey:@"body"];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        id did = [userDefaults valueForKey:@"device-did"];
        
        if(did){
            [body addItemValue:[NSString stringWithFormat:@"%@", did] forKey:@"device-did"];
        }
        
        id uid = [self.context uid];
        
        if(uid){
            [body addItemValue:[NSString stringWithFormat:@"%@", uid] forKey:@"auth-uid"];
        }
        
        id token = [self.context token];
        
        if(token){
            [body addItemValue:[NSString stringWithFormat:@"%@", token] forKey:@"auth-token"];
        }
    
        [body release];
        
        [self.context handle:@protocol(IVTAPIRequestTask) task:httpTask priority:0];
        
        [httpTask release];
        
        return YES;
    }
    else if(taskType == @protocol(IVTAPIResponseTask)){
        
        id<IVTAPIResponseTask> respTask = (id<IVTAPIResponseTask>) task;
        
        if([respTask taskType] == @protocol(IVTFeedbackTask)){
            
            if([respTask error]){
                
                NSLog(@"%@",[respTask error]);
                
                [self vtUplinkTask:[respTask task] didFailWithError:[respTask error] forTaskType:[respTask taskType]];
            }
            else{
                
                NSLog(@"%@",[respTask resultsData]);
                
                [self vtUplinkTask:[respTask task] didSuccessResults:[respTask resultsData]
                       forTaskType:[respTask taskType]];
            }
            
            return YES;
        }
        
    }
    return NO;
}

@end
