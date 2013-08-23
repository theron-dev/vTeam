//
//  VTImageService.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTImageService.h"

#import "IVTImageTask.h"

#include "md5.h"

@interface VTImageService(){
    NSMutableDictionary * _imageCached;
    NSMutableArray * _imageTasks;
}

@end

@implementation VTImageService

-(void) dealloc{
    [_imageTasks release];
    [_imageCached release];
    [super dealloc];
}

+(NSString *) keySrc:(NSString *)src{
    
    md5_state_t md5;
    md5_byte_t digest[16];
    int i;
    
    md5_init(&md5);
    
    NSData * bytes = [src dataUsingEncoding:NSUTF8StringEncoding];
    
    md5_append(&md5, [bytes bytes], [bytes length]);
    
    md5_finish(&md5, digest);
    
    NSMutableString * md5String = [NSMutableString stringWithCapacity:32];
    
    for(i=0;i<16;i++){
        [md5String appendFormat:@"%02x",digest[i]];
    }
    
    return md5String;
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if([task conformsToProtocol:@protocol(IVTImageTask)]){
        
        id<IVTImageTask> imageTask = (id<IVTImageTask>) task;
        
        NSString * defaultSrc = [imageTask defaultSrc];
        
        if(defaultSrc){
            if([defaultSrc hasPrefix:@"@"]){
                [imageTask setDefaultImage:[UIImage imageNamed:[defaultSrc substringFromIndex:1]]];
            }
            else{
                NSString * key = [VTImageService keySrc:defaultSrc];
                UIImage * image = [_imageCached objectForKey:key];
                if(image){
                    [imageTask setDefaultImage:image];
                }
                else if([defaultSrc hasPrefix:@"http://"]){
                    
                    VTHttpTask * httpTask = [[VTHttpTask alloc] init];
                    
                    NSURL * URL = [NSURL URLWithString:defaultSrc];
                    
                    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[[self.config valueForKey:@"timeout"] doubleValue]];
                    
                    [request setValue:[NSString stringWithFormat:@"%@://%@%@",URL.scheme,URL.host,URL.path] forHTTPHeaderField:@"Referer"];
                    
                    [httpTask setRequest:request];
                    
                    [httpTask setResponseType:VTHttpTaskResponseTypeResource];
                    [httpTask setAllowCheckContentLength:YES];
                    [httpTask setSource:imageTask];
                    [httpTask setDelegate:self];
                    [httpTask setOnlyLocalResource:YES];
                    [httpTask setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:imageTask,@"imageTask",@"defaultImage",@"keyPath", nil]];
                    [httpTask setAllowWillRequest:YES];
                    
                    [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
                    
                    [httpTask release];
                    
                }
                else{
                    
                    image = [UIImage imageWithContentsOfFile:defaultSrc];
                    
                    if(image){
                        if(_imageCached == nil){
                            _imageCached = [[NSMutableDictionary alloc] init];
                        }
                        [_imageCached setObject:image forKey:key];
                        [imageTask setDefaultImage:image];
                    }
                    else{
                        [imageTask setDefaultImage:nil];
                    }
                    
                }
            }
        }
        
        NSString * src = [imageTask src];
        
        if(src){
            if([src hasPrefix:@"@"]){
                [imageTask setHttpTask:nil];
                [imageTask setImage:[UIImage imageNamed:[src substringFromIndex:1]] isLocal:YES];
            }
            else{
                NSString * key = [VTImageService keySrc:src];
                UIImage * image = [_imageCached objectForKey:key];
                if(image){
                    [imageTask setHttpTask:nil];
                    [imageTask setImage:image isLocal:YES];
                }
                else if([src hasPrefix:@"http://"]){
                    
                    VTHttpTask * httpTask = [[VTHttpTask alloc] init];
                    
                    NSURL * URL = [NSURL URLWithString:src];
                    
                    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[[self.config valueForKey:@"timeout"] doubleValue]];
                    
                    [request setValue:[NSString stringWithFormat:@"%@://%@%@",URL.scheme,URL.host,URL.path] forHTTPHeaderField:@"Referer"];
                    
                    [httpTask setRequest:request];
                    
                    [httpTask setResponseType:VTHttpTaskResponseTypeResource];
                    [httpTask setAllowCheckContentLength:YES];
                    [httpTask setSource:imageTask];
                    [httpTask setDelegate:self];
                    [httpTask setAllowWillRequest:YES];
                    
                    if(taskType == @protocol(IVTLocalImageTask)){
                        [httpTask setOnlyLocalResource:YES];
                        [httpTask setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:imageTask,@"imageTask",@"image",@"keyPath", nil]];
                    }
                    else{
                        
                        [httpTask setOnlyLocalResource:NO];
                    
                        [imageTask setHttpTask:httpTask];
                    
                        if(_imageTasks == nil){
                            _imageTasks = [[NSMutableArray alloc] init];
                        }
                    
                        [_imageTasks addObject:imageTask];
                    }
                    
                    [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
                    
                    [httpTask release];
                    
                }
                else{
                    
                    image = [UIImage imageWithContentsOfFile:src];
                    
                    if(image){
                        if(_imageCached == nil){
                            _imageCached = [[NSMutableDictionary alloc] init];
                        }
                        [_imageCached setObject:image forKey:key];
                        [imageTask setHttpTask:nil];
                        [imageTask setImage:image isLocal:YES];
                    }
                    else{
                        [imageTask setHttpTask:nil];
                        [imageTask setImage:nil isLocal:YES];
                    }
                    
                }
            }
        }
        else{
            [imageTask setHttpTask:nil];
            [imageTask setImage:nil isLocal:NO];
        }
        
        if(_imageTasks == nil){
            _imageTasks = [[NSMutableArray alloc] init];
        }
        
        [_imageTasks addObject:task];
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    NSInteger c = [_imageTasks count];
    
    NSInteger i = 0;
    
    while(i <c){
        
        id item = [_imageTasks objectAtIndex:i];
        
        if(item == task){
            
            if([item httpTask]){
                [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:[item httpTask]];
                [item setHttpTask:nil];
            }
            
            [_imageTasks removeObjectAtIndex:i];
            
            c --;
        }
        else{
            i ++;
        }
        
    }
    
    return YES;
}

-(BOOL) cancelHandleForSource:(id) source{
    
    NSInteger c = [_imageTasks count];
    
    NSInteger i = 0;
    
    while(i <c){
        
        id item = [_imageTasks objectAtIndex:i];
        
        if([item source] == source){
            
            if([item httpTask]){
                [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:[item httpTask]];
                [item setHttpTask:nil];
            }
            
            [_imageTasks removeObjectAtIndex:i];
            
            c --;
        }
        else{
            i ++;
        }
        
    }
    
    return NO;
}

-(void) didReceiveMemoryWarning{
    NSDictionary * dict = [NSDictionary dictionaryWithDictionary:_imageCached];
    for(NSString * key in dict){
        UIImage * image = [_imageCached objectForKey:key];
        if([image retainCount] <=2){
            [_imageCached removeObjectForKey:key];
        }
    }
}

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error{
    
    if([httpTask userInfo]){
        
        NSString *keyPath = [[httpTask userInfo] valueForKey:@"keyPath"];
        
        id<IVTImageTask> imageTask = (id<IVTImageTask>)[[httpTask userInfo] valueForKey:@"imageTask"];
       
        if([keyPath isEqualToString:@"image"]){
            [imageTask setImage:nil isLocal:YES];
        }
        else{
            [(id)imageTask setValue:nil forKeyPath:keyPath];
        }
        
    }
    else{
        id<IVTImageTask> imageTask = [httpTask source];
        if([imageTask conformsToProtocol:@protocol(IVTImageTask)]){
            
            [imageTask setHttpTask:nil];

            [imageTask setImage:nil isLocal:NO];

            [_imageTasks removeObject:imageTask];

            
        }
    }
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    if([httpTask userInfo]){
        
        NSString *keyPath = [[httpTask userInfo] valueForKey:@"keyPath"];
        
        id<IVTImageTask> imageTask = (id<IVTImageTask>)[[httpTask userInfo] valueForKey:@"imageTask"];
        
        UIImage * image = [UIImage imageWithContentsOfFile:[httpTask responseBody]];
        
        if(image){
            
            NSString * key = [VTImageService  keySrc:[imageTask src]];
            
            if(_imageCached == nil){
                _imageCached = [[NSMutableDictionary alloc] init];
            }
            
            [_imageCached setObject:image forKey:key];
        }
        
        if([keyPath isEqualToString:@"image"]){
            [imageTask setImage:image isLocal:YES];
        }
        else{
            [(id)imageTask setValue:image forKeyPath:keyPath];
        }
    }
    else {
        id<IVTImageTask> imageTask = [httpTask source];
        
        if([imageTask conformsToProtocol:@protocol(IVTImageTask)]){
            
            UIImage * image = [UIImage imageWithContentsOfFile:[httpTask responseBody]];
            
            if(image){
                
                NSString * key = [VTImageService  keySrc:[imageTask src]];
                
                if(_imageCached == nil){
                    _imageCached = [[NSMutableDictionary alloc] init];
                }
                
                [_imageCached setObject:image forKey:key];
            }
            
            [imageTask setHttpTask:nil];

            [imageTask setImage:image isLocal:NO];

            [_imageTasks removeObject:imageTask];

        }
    }
}

@end
