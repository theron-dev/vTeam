//
//  VTCrashService.m
//  vTeam
//
//  Created by zhang hailong on 13-11-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTCrashService.h"

#import "VTCrashTask.h"

#import "UIDevice+VTUUID.h"

#import <execinfo.h>

static VTCrashService * gVTCrashService = nil;

static void VTCrashServiceUncaughtExceptionHandler(NSException *exception){
    
    VTCrashTask * task = [[VTCrashTask alloc] init];
    [task setException:exception];
    [gVTCrashService.context handle:@protocol(IVTCrashTask) task:task priority:0];
    [task release];
    
}

static void VTCrashServiceSignalHandler(int signal)
{
    
    NSException * exception = [[NSException alloc] initWithName:@"VTCrashServiceSignal" reason:[NSString stringWithFormat:@"signal:%d, errno:%d",signal,errno] userInfo:nil];
    [exception raise];
    [exception release];
}

@implementation VTCrashService

-(id) init{
    
    if((self = [super init])){
        
        NSSetUncaughtExceptionHandler(VTCrashServiceUncaughtExceptionHandler);
        
        signal(SIGABRT, VTCrashServiceSignalHandler);
        signal(SIGILL, VTCrashServiceSignalHandler);
        signal(SIGSEGV, VTCrashServiceSignalHandler);
        signal(SIGFPE, VTCrashServiceSignalHandler);
        signal(SIGBUS, VTCrashServiceSignalHandler);
        signal(SIGPIPE, VTCrashServiceSignalHandler);
        
        gVTCrashService = self;
    }
    
    return self;
}

-(void) dealloc{
    
    if(gVTCrashService == self){
        gVTCrashService = nil;
    }
    
    [super dealloc];
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    
    if(@protocol(IVTCrashTask) == taskType){
        
        
        NSException * exception = [(id<IVTCrashTask>)task exception];
        
        if(exception){
            
            VTHttpFormBody * body = [[VTHttpFormBody alloc] init];
            
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
            
            NSMutableDictionary * data = [NSMutableDictionary dictionaryWithCapacity:4];
            
            [data setValue:exception.name forKey:@"name"];
            [data setValue:exception.reason forKey:@"reason"];
            [data setValue:exception.callStackSymbols forKey:@"callStackSymbols"];
            [data setValue:exception.callStackReturnAddresses forKey:@"callStackReturnAddresses"];
            
            void * array[30];
            
            int size = backtrace(array,30);
            
            NSMutableString * backtraceString = [NSMutableString stringWithCapacity:128];
            
            char ** symbols = backtrace_symbols(array,size);
            
            for(int i=0;i<size;i++){
                [backtraceString appendFormat:@"%s\n",symbols[i]];
            }
            
            if(symbols){
                free(symbols);
            }
            
            [data setValue:backtraceString forKey:@"backtrace"];
            
            [body addItemValue:[VTJSON encodeObject:data] forKey:@"exception"];
            
            NSURL * url = [NSURL URLWithString:[self.config valueForKey:@"url"]];
            
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[body bytesBody]];
            [request addValue:[body contentType] forHTTPHeaderField:@"ContentType"];
            
            NSHTTPURLResponse * response = nil;
            NSError * error = nil;
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:& error];
            
            if(error){
                NSLog(@"%@",error);
            }
            else if(response){
                NSLog(@"%d",[response statusCode]);
                NSLog(@"%@",[response allHeaderFields]);
            }
            
            [body release];
            
        }
        
        return YES;
    }
    
    return NO;
}

@end
