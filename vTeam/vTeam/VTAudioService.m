//
//  VTAudioService.m
//  vTeam
//
//  Created by zhang hailong on 14-1-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTAudioService.h"

#import "NSString+VTMD5String.h"

@interface VTAudioServiceHttpTask : VTHttpTask

@property(nonatomic,retain) NSString * audio;
@property(nonatomic,readonly) NSMutableSet * audioTasks;

@end

@implementation VTAudioServiceHttpTask

@synthesize audio = _audio;
@synthesize audioTasks = _audioTasks;

-(void) dealloc{
    [_audio release];
    [_audioTasks release];
    [super dealloc];
}

-(NSMutableSet *) audioTasks{
    
    if(_audioTasks == nil){
        _audioTasks = [[NSMutableSet alloc] initWithCapacity:2];
    }
    
    return _audioTasks;
}

@end

@interface VTAudioService ()

@property(nonatomic,readonly) NSMutableArray * httpTasks;

@end

@implementation VTAudioService

@synthesize httpTasks = _httpTasks;

-(void) dealloc{
    for(VTAudioServiceHttpTask * httpTask in _httpTasks){
        [httpTask setDelegate:nil];
    }
    [_httpTasks release];
    [super dealloc];
}

-(NSMutableArray *) httpTasks{
    
    if(_httpTasks == nil){
        _httpTasks = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    return _httpTasks;
}

-(NSString *) absoluteURL:(NSString *)url{
    
    if(url == nil){
        return nil;
    }
    
    if([url hasPrefix:@"@"]){
        return url;
    }
    
    if([url hasPrefix:@"http://"]){
        return url;
    }
    
    NSRange r = [url rangeOfString:@"://"];
    
    if(r.location != NSNotFound){
        
        NSString * scheme = [url substringToIndex:r.location];
        
        NSString * baseUrl = [self.config valueForKey:scheme];
        
        if(baseUrl){
            return [baseUrl stringByAppendingString:[url substringFromIndex:r.location + r.length]];
        }
        
    }
    
    return url;
    
}

-(NSString *) audioLocalFilePath:(NSString *) url{
    
    NSString * dir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"audios"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:dir]){
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * u = [self absoluteURL:url];
    
    NSString * ext = [u pathExtension];
    
    NSString * n = [u vtMD5String];
    
    if([ext length]){
        n = [n stringByAppendingPathExtension:ext];
    }
    
    return [dir stringByAppendingPathComponent:n];
}

-(BOOL) isPlaying:(id<IVTAudioPlayTask>) playTask{
    return NO;
}

-(BOOL) play:(id<IVTAudioPlayTask>) playTask{
    return NO;
}

-(void) stop:(id<IVTAudioPlayTask>) playTask{
    
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if(taskType == @protocol(IVTAudioPlayTask) || taskType == @protocol(IVTAudioTask)){
        
        id<IVTAudioTask> audioTask = (id<IVTAudioTask>) task;
        
        [audioTask setStatus:VTAudioTaskStatusNone];
        
        if([task conformsToProtocol:@protocol(IVTAudioPlayTask)]
           && [self isPlaying: (id<IVTAudioPlayTask>) audioTask]){
            [audioTask setStatus:VTAudioTaskStatusPlaying];
        }
        else{
            
            NSString * localFile = [self audioLocalFilePath:[audioTask url]];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:localFile]){
                [audioTask setStatus:VTAudioTaskStatusLoaded];
            }
            else{
                
                NSString * audio = [audioTask url];
                
                for (VTAudioServiceHttpTask * httpTask in _httpTasks) {
                    
                    if([[httpTask audio] isEqualToString:audio]){
                        [[httpTask audioTasks] addObject:audioTask];
                        [audioTask setStatus:VTAudioTaskStatusLoading];
                        break;
                    }
                    
                }
                
            }
            
        }
        
    }
    
    if(taskType == @protocol(IVTAudioPlayTask)){
        
        id<IVTAudioPlayTask> audioTask = (id<IVTAudioPlayTask>) task;
        
        switch ([audioTask status]) {
            case VTAudioTaskStatusLoaded:
            {
                if([self play:audioTask]){
                    [audioTask setStatus:VTAudioTaskStatusPlaying];
                }
            }
                break;
            case VTAudioTaskStatusLoading:
            {
                [audioTask setCancelPlay:NO];
            }
                break;
            case VTAudioTaskStatusPlaying:
            {
            }
                break;
            case VTAudioTaskStatusNone:
            {
                
                NSFileManager * fileManager = [NSFileManager defaultManager];
                
                NSString * url = [self absoluteURL:[audioTask url]];
                
                if([url hasPrefix:@"http://"]){
                    
                    VTAudioServiceHttpTask * httpTask = [[VTAudioServiceHttpTask alloc] init];
                    
                    [httpTask setResponseType:VTHttpTaskResponseTypeResource];
                    [httpTask setAudio:[audioTask url]];
                    [[httpTask audioTasks] addObject:audioTask];
                    
                    NSTimeInterval timeout = [[self.config valueForKey:@"timeout"] doubleValue];
                    
                    if(timeout < 0.0){
                        timeout = 300;
                    }
                    
                    NSURLRequest * request =[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
                    
                    [httpTask setRequest:request];
                    [httpTask setDelegate:self];
                    
                    [self.httpTasks addObject:httpTask];
                    
                    [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
                    
                    [audioTask setStatus:VTAudioTaskStatusLoading];
                    [audioTask setCancelPlay:NO];
                }
                else if([fileManager fileExistsAtPath:url]){
                    
                    [fileManager copyItemAtPath:url toPath:[self audioLocalFilePath:[audioTask url]] error:nil];
                    
                    [audioTask setStatus:VTAudioTaskStatusLoaded];
                    
                    if([self play:audioTask]){
                        [audioTask setStatus:VTAudioTaskStatusPlaying];
                    }
                }
 
            }
                break;
            default:
                break;
        }
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    if(taskType == @protocol(IVTAudioPlayTask) || taskType == @protocol(IVTAudioTask)){
        
        id<IVTAudioPlayTask> audioTask = (id<IVTAudioPlayTask>) task;
        
        if([task conformsToProtocol:@protocol(IVTAudioPlayTask)]){
            
            if([self isPlaying:audioTask]){
                [self stop:audioTask];
            }
            
            [audioTask setCancelPlay:YES];
        }
    }
    
    if(taskType == @protocol(IVTAudioTask)){

        id<IVTAudioPlayTask> audioTask = (id<IVTAudioPlayTask>) task;
        
        NSString * audio = [audioTask url];
        
        for (VTAudioServiceHttpTask * httpTask in [NSArray arrayWithArray:_httpTasks]) {
            
            if([[httpTask audio] isEqualToString:audio]){
                
                for(id<IVTAudioPlayTask> playTask in [httpTask audioTasks]){
                    [playTask setStatus:VTAudioTaskStatusNone];
                }
                
                [audioTask setStatus:VTAudioTaskStatusNone];
                
                [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:httpTask];
                [_httpTasks removeObject:httpTask];
            }
            
        }
        
        return YES;
    }
    
    return NO;
}

-(void) vtHttpTask:(id)httpTask didFailError:(NSError *)error{
    
    for(id<IVTAudioPlayTask> playTask in [httpTask audioTasks]){
        [playTask setStatus:VTAudioTaskStatusNone];
    }
    
    [self.httpTasks removeObject:httpTask];
}

-(void) vtHttpTaskDidLoaded:(id)httpTask{
    
    [[NSFileManager defaultManager] moveItemAtPath:[httpTask responseBody] toPath:[self audioLocalFilePath:[httpTask audio]] error:nil];

    for(id<IVTAudioPlayTask> playTask in [httpTask audioTasks]){
        
        if([playTask conformsToProtocol:@protocol(IVTAudioPlayTask)]){
            
            if(![playTask isCancelPlay]){
                if([self play:playTask]){
                    [playTask setStatus:VTAudioTaskStatusPlaying];
                }
            }
            
        }

    }
    
    [self.httpTasks removeObject:httpTask];
}

@end
