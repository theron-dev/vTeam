//
//  VTHttpService.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHttpService.h"

#import "VTHttpTask.h"

@interface VTHttpTaskOperator : NSOperation{
    
}

@property(assign) Protocol * taskType;
@property(retain) VTHttpTask * task;
@property(retain) NSURLConnection * conn;
@property(assign) BOOL finished;
@property(readonly) NSTimeInterval timeout;
@property(assign) BOOL executing;
@property(assign) NSOperationQueue * queue;
@property(retain) NSURLRequest * request;
@property(assign,getter = isAllowShowNetworkStatus) BOOL allowShowNetworkStatus;

-(id)initWithTask:(id) task timeout:(NSTimeInterval) timeout;

@end

@implementation VTHttpTaskOperator

@synthesize taskType = _taskType;
@synthesize task = _task;
@synthesize finished = _finished;
@synthesize conn = _conn;
@synthesize timeout = _timeout;
@synthesize executing = _executing;
@synthesize queue = _queue;
@synthesize request = _request;
@synthesize allowShowNetworkStatus = _allowShowNetworkStatus;

-(id)initWithTask:(id) task timeout:(NSTimeInterval) timeout{
    if((self = [super init])){
        _task = [task retain];
        _timeout = timeout;
        
        self.request = [_task doWillRequeset];
        
        if(_request == nil){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    
    NSOperationQueue * opQueue = _queue;
    
    if(_allowShowNetworkStatus && opQueue){
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            UIApplication * app = [UIApplication sharedApplication];
            
            if([opQueue operationCount] ==0){
                if([app isNetworkActivityIndicatorVisible]){
                    [app setNetworkActivityIndicatorVisible:NO];
                }
            }
            else{
                if(![app isNetworkActivityIndicatorVisible]){
                    [app setNetworkActivityIndicatorVisible:YES];
                }
            }
            
        });
    }
    [_conn cancel];
    [_conn release];
    [_request release];
    [NSObject cancelPreviousPerformRequestsWithTarget:_task];
    [_task release];
    [super dealloc];
}


-(BOOL) isReady{
    return YES;
}

-(BOOL) isConcurrent{
    return YES;
}

-(void) connectTimeout{
    [_conn cancel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.conn = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doFailError:
         [NSError errorWithDomain:@"VTHttpService" code:-3 userInfo:[NSDictionary dictionaryWithObject:@"http connect timeout" forKey:NSLocalizedDescriptionKey]]];
        
        self.finished = YES;
    });
    
}

- (void)start{
    
    if([self isCancelled]){
        return;
    }
    
    self.executing = YES;
    
    NSOperationQueue * opQueue = [NSOperationQueue currentQueue];
    
    self.queue = opQueue;
    
    if(_allowShowNetworkStatus ){
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            UIApplication * app = [UIApplication sharedApplication];
            
            if([opQueue operationCount] ==0){
                if([app isNetworkActivityIndicatorVisible]){
                    [app setNetworkActivityIndicatorVisible:NO];
                }
            }
            else{
                if(![app isNetworkActivityIndicatorVisible]){
                    [app setNetworkActivityIndicatorVisible:YES];
                }
            }
            
        });
    }
    
    NSRunLoop * runloop = [NSRunLoop currentRunLoop];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doLoading];
    
    });
    
    
    self.conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
    
    [_conn start];
    
    if(_timeout){
        [self performSelector:@selector(connectTimeout) withObject:nil afterDelay:_timeout];
    }
    
    while(![self isCancelled] && !_finished){
        [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]];
    }
    
    self.executing = NO;
}

-(void) cancel{
    [super cancel];
    [_conn cancel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.conn = nil;
    self.finished = YES;
}

- (BOOL)isExecuting{
    return _executing;
}

- (BOOL)isFinished{
    return _finished;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(self.isCancelled){
            return;
        }
        
        [self.task doFailError:error];
        
        self.finished = YES;
        
    });
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.task doBackgroundLoaded];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doLoaded];
        
        self.finished = YES;
    });
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
   
    [self.task doBackgroundReceiveData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doReceiveData:data];

    });
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    [self.task doBackgroundResponse:(NSHTTPURLResponse *)response];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doResponse];
        
    });
}

- (void)connection:(NSURLConnection *)connection  didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if(self.isCancelled){
            return;
        }
        
        [self.task doSendBodyDataBytesWritten:bytesWritten totalBytesWritten:totalBytesWritten];
        
    });
}

@end

@interface VTHttpService(){
    NSOperationQueue * _operationQueue;
}
@end

@implementation VTHttpService

-(void) dealloc{
    [_operationQueue cancelAllOperations];
    [_operationQueue release];
    [super dealloc];
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if([task conformsToProtocol:@protocol(IVTHttpTask)]){
        
        if(_operationQueue == nil){
            _operationQueue = [[NSOperationQueue alloc] init];
            
            int maxThreadCount = [[self.config valueForKey:@"maxThreadCount"] intValue];
            
            if(maxThreadCount < 1){
                maxThreadCount = 1;
            }
            
            [_operationQueue setMaxConcurrentOperationCount:maxThreadCount];
        }
        
        VTHttpTaskOperator * op = [[VTHttpTaskOperator alloc] initWithTask:task timeout:[[self.config valueForKey:@"timeout"] doubleValue]];
        [op setAllowShowNetworkStatus:[[self.config valueForKey:@"allowShowNetworkStatus"] boolValue]];
        [op setTaskType:taskType];
        [_operationQueue addOperation:op];
        [op release];
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    NSArray * ops = [_operationQueue operations];
    
    for(VTHttpTaskOperator * op in ops){
        if(op.taskType == taskType && (task == nil || task == op.task)){
            [op cancel];
        }
    }

    return YES;
}

-(BOOL) cancelHandleForSource:(id) source{
    
    NSArray * ops = [_operationQueue operations];
    
    for(VTHttpTaskOperator * op in ops){
        if(op.task.source == source){
            [op cancel];
        }
    }
    
    return NO;
}


@end
