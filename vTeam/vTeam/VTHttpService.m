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
        
        if([_task isAllowWillRequest]){
            self.request = [_task doWillRequeset];
            if(_request == nil){
                [self release];
                return nil;
            }
        }
    }
    return self;
}

static void VTHttpTaskOperatorDeallocDispatchFunction(void * queue){
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    UIApplication * app = [UIApplication sharedApplication];
    
    if([(NSOperationQueue *)queue operationCount] ==0){
        if([app isNetworkActivityIndicatorVisible]){
            [app setNetworkActivityIndicatorVisible:NO];
        }
    }
    else{
        if(![app isNetworkActivityIndicatorVisible]){
            [app setNetworkActivityIndicatorVisible:YES];
        }
    }
    
    [(NSOperationQueue *)queue release];
    
    [pool release];
    
}

static void VTHttpTaskOperatorDeallocTaskReleaseDispatchFunction(void * task){
    
    [(id) task release];
}

-(void) dealloc{
    
    NSOperationQueue * opQueue = _queue;
    
    if(_allowShowNetworkStatus && opQueue){
        [opQueue retain];
        dispatch_async_f(dispatch_get_main_queue(), opQueue, VTHttpTaskOperatorDeallocDispatchFunction);
    }
    
    [_conn cancel];
    [_conn release];
    [_request release];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:_task];
    
    dispatch_async_f(dispatch_get_main_queue(), _task, VTHttpTaskOperatorDeallocTaskReleaseDispatchFunction);

    [super dealloc];
}


-(BOOL) isReady{
    return YES;
}

-(BOOL) isConcurrent{
    return YES;
}

-(void) mainDoFailError:(NSError *) error{
    
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doFailError:error];
    
    self.finished = YES;
    
    [pool release];
}

-(void) connectTimeout{
    [_conn cancel];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.conn = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(mainDoFailError:) withObject:[NSError errorWithDomain:@"VTHttpService" code:-3 userInfo:[NSDictionary dictionaryWithObject:@"http connect timeout" forKey:NSLocalizedDescriptionKey]] afterDelay:0.0];
    });
  
}

-(void) mainDoLoading{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doLoading];
    
    [pool release];
    
}

-(void) startRequest{
    
    if(self.isCancelled){
        return;
    }
    
    if(self.request == nil){
        _finished = YES;
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self mainDoLoading];
        
    });
    
    self.conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
    
    [_conn start];
    
    if(_timeout){
        [self performSelector:@selector(connectTimeout) withObject:nil afterDelay:_timeout];
    }

}

-(void) mainWillRequest:(NSThread *) thread{
    
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    self.request = [_task doWillRequeset];
    
    [self performSelector:@selector(startRequest) onThread:thread withObject:nil waitUntilDone:NO];
    
    [pool release];
    
}

- (void) main{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if([self isCancelled]){
        return;
    }
    
    self.executing = YES;

    NSOperationQueue * opQueue = [NSOperationQueue currentQueue];
    
    self.queue = opQueue;
    
    if(_allowShowNetworkStatus ){
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
            
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
            
            [pool release];
            
        });
        
    }
    
    NSRunLoop * runloop = [NSRunLoop currentRunLoop];
    
    if(![_task isAllowWillRequest]){
        
        NSThread * thread = [NSThread currentThread];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self mainWillRequest:thread];

        });
        
    }
    else{
        [self startRequest];
    }
    
    while(![self isCancelled] && !_finished){
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        [runloop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.8]];
        [pool release];
    }
    
    self.executing = NO;
    
    [pool release];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
    

        [self mainDoFailError:error];

    });
    
}

-(void) didLoaded{
    
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doLoaded];
    
    self.finished = YES;
    
    [pool release];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self.task doBackgroundLoaded];
   
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self didLoaded];
        
    });
   
}

-(void) mainDoReceiveData:(NSData *) data{
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doReceiveData:data];
    
    [pool release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    [self.task doBackgroundReceiveData:data];
    
    if([self.task hasDoReceiveData]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self mainDoReceiveData:data];
        });
    }
}

-(void) mainDoResponse{
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doResponse];
    
    [pool release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    if([self.task isAllowStatusCode302]){
        if([(NSHTTPURLResponse *) response statusCode] == 302){
            NSString * url = [[(NSHTTPURLResponse *) response allHeaderFields] valueForKey:@"Location"];
            if(url){
                self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeout];
                [_conn cancel];
                self.conn = nil;
                [self startRequest];
                return ;
            }
        }
    }
    
    [self.task doBackgroundResponse:(NSHTTPURLResponse *)response];
    
    if([self.task hasDoResponse]){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self mainDoResponse];
            
        });
    }
    
}

-(void) mainDoSendBodyDataBytes:(NSDictionary *) userInfo{
    
    if(self.isCancelled){
        return;
    }
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    [self.task doSendBodyDataBytesWritten:[[userInfo valueForKey:@"bytesWritten"] intValue] totalBytesWritten:[[userInfo valueForKey:@"totalBytesWritten"] intValue]];
    
    [pool release];

}

- (void)connection:(NSURLConnection *)connection  didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    if(_conn != connection || [self isCancelled]){
        return;
    }
    
    if([self.task hasDoSendBodyDataBytes]){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:bytesWritten],@"bytesWritten",[NSNumber numberWithInteger:totalBytesWritten],@"totalBytesWritten", nil];
            
            [self mainDoSendBodyDataBytes:userInfo];

        });
        
    }

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
    
    NSArray * ops = [NSArray arrayWithArray:[_operationQueue operations]];
    
    for(VTHttpTaskOperator * op in ops){
        if(op.taskType == taskType && (task == nil || task == op.task)){
            [op cancel];
        }
    }

    return YES;
}

-(BOOL) cancelHandleForSource:(id) source{
    
    NSArray * ops = [NSArray arrayWithArray:[_operationQueue operations]];
    
    for(VTHttpTaskOperator * op in ops){
        if(op.task.source == source){
            [op cancel];
        }
    }
    
    return NO;
}


@end
