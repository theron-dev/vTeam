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
    NSMutableDictionary * _imageTasks;
    NSMutableDictionary * _httpTasks;
}

@end

@implementation VTImageService

-(void) dealloc{
    [_imageTasks release];
    [_imageCached release];
    [_httpTasks release];
    [super dealloc];
}

+(NSString *) keySrc:(NSString *)src{
    
    md5_state_t md5;
    md5_byte_t digest[16];
    int i;
    
    md5_init(&md5);
    
    NSData * bytes = [src dataUsingEncoding:NSUTF8StringEncoding];
    
    md5_append(&md5, [bytes bytes], (int) [bytes length]);
    
    md5_finish(&md5, digest);
    
    NSMutableString * md5String = [NSMutableString stringWithCapacity:32];
    
    for(i=0;i<16;i++){
        [md5String appendFormat:@"%02x",digest[i]];
    }
    
    return md5String;
}

-(NSString *) absoluteSrc:(NSString *)src{
    
    if(src == nil){
        return nil;
    }
    
    if([src hasPrefix:@"@"]){
        return src;
    }
    
    if([src hasPrefix:@"http://"]){
        return src;
    }
    
    NSRange r = [src rangeOfString:@"://"];
    
    if(r.location != NSNotFound){
        
        NSString * scheme = [src substringToIndex:r.location];
        
        NSString * baseUrl = [self.config valueForKey:scheme];
        
        if(baseUrl){
            return [baseUrl stringByAppendingString:[src substringFromIndex:r.location + r.length]];
        }
        
    }
    
    return src;
}

-(BOOL) handle:(Protocol *)taskType task:(id<IVTTask>)task priority:(NSInteger)priority{
    
    if([task conformsToProtocol:@protocol(IVTImageTask)]){
        
        id<IVTImageTask> imageTask = (id<IVTImageTask>) task;
        
        NSString * defaultSrc = [self absoluteSrc:[imageTask defaultSrc]];
       
        if(defaultSrc){
            if([defaultSrc hasPrefix:@"@"]){
                [imageTask setDefaultImage:[UIImage imageNamed:[defaultSrc substringFromIndex:1]]];
            }
            else{
                
                NSString * key = [VTImageService keySrc:defaultSrc];
                
                UIImage * image = [_imageCached objectForKey:key];
                
                if(image == nil){
                    
                    if([defaultSrc hasPrefix:@"http://"]){
                        NSString * localPath = [VTHttpTask localResourcePathForURL:[NSURL URLWithString:defaultSrc]];
                        image = [UIImage imageWithContentsOfFile:localPath];
                    }
                    else {
                        image = [UIImage imageNamed:defaultSrc];
                    }
                    
                    if(image){
                        if(_imageCached == nil){
                            _imageCached = [[NSMutableDictionary alloc] init];
                        }
                        
                        [_imageCached setObject:image forKey:key];
                    }
                }
                
                if(image){
                    [imageTask setDefaultImage:image];
                }
            }
        }
        
        NSString * src = [self absoluteSrc:[imageTask src]];
        
        if(src){
            if([src hasPrefix:@"@"]){
                [imageTask setLoading:NO];
                [imageTask setImage:[UIImage imageNamed:[src substringFromIndex:1]] isLocal:YES];
            }
            else{
                NSString * key = [VTImageService keySrc:src];
                UIImage * image = [_imageCached objectForKey:key];
                
                if(image == nil){
                    
                    NSString * localPath = [VTHttpTask localResourcePathForURL:[NSURL URLWithString:src]];
                    
                    image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if(image){
                        if(_imageCached == nil){
                            _imageCached = [[NSMutableDictionary alloc] init];
                        }
                        
                        [_imageCached setObject:image forKey:key];
                    }
                }
                
                if(image){
                    [imageTask setLoading:NO];
                    [imageTask setImage:image isLocal:YES];
                }
                else if([src hasPrefix:@"http://"]){
                    
                    if(taskType != @protocol(IVTLocalImageTask)){
                        
                        NSMutableArray * imageTasks = [_imageTasks objectForKey:key];
                        
                        if(imageTasks){
                            [imageTasks addObject:imageTask];
                            [imageTask setLoading:YES];
                        }
                        else{
        
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
                            [httpTask setUserInfo:[NSDictionary dictionaryWithObject:key forKey:@"key"]];
                            
                            if(_imageTasks == nil){
                                _imageTasks = [[NSMutableDictionary alloc] init];
                            }
                            
                            [_imageTasks setValue:[NSMutableArray arrayWithObject:imageTask] forKey:key];
                            
                            [imageTask setLoading:YES];
                            
                            if(_httpTasks == nil){
                                _httpTasks = [[NSMutableDictionary alloc] init];
                            }
                            
                            [_httpTasks setObject:httpTask forKey:key];
                            
                            [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
                            
                            [httpTask release];
                        }
                    }
  
                }
                else{
                    
                    image = [UIImage imageNamed:src];
                    
                    if(image){
                        if(_imageCached == nil){
                            _imageCached = [[NSMutableDictionary alloc] init];
                        }
                        [_imageCached setObject:image forKey:key];
                        [imageTask setLoading:NO];
                        [imageTask setImage:image isLocal:YES];
                    }
                    else{
                        [imageTask setLoading:NO];
                        [imageTask setImage:nil isLocal:YES];
                    }
                    
                }
            }
        }
        else{
            [imageTask setLoading:NO];
            [imageTask setImage:nil isLocal:NO];
        }
        
        return YES;
    }
    
    return NO;
}

-(BOOL) cancelHandle:(Protocol *)taskType task:(id<IVTTask>)task{
    
    id<IVTImageTask> imageTask = (id<IVTImageTask>) task;
    
    NSString * src = [imageTask src];
    
    if([src hasPrefix:@"http://"]){
        NSString * key = [VTImageService keySrc:src];
        NSMutableArray * imageTasks = [_imageTasks objectForKey:key];
        if(imageTasks){
            [imageTasks removeObject:imageTask];
            [imageTask setLoading:NO];
            if([imageTasks count] == 0){
                [_imageTasks removeObjectForKey:key];
                id httpTask = [_httpTasks objectForKey:key];
                if(httpTask){
                    [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:httpTask];
                    [_httpTasks removeObjectForKey:key];
                }
            }
        }
    }
    
    return YES;
}

-(BOOL) cancelHandleForSource:(id) source{
    
    for(NSString * key in [_imageTasks allKeys]){
        
        NSMutableArray * tasks = [_imageTasks objectForKey:key];
        
        NSInteger c = [tasks count];
        
        NSInteger i = 0;
        
        while(i <c){
            
            id item = [tasks objectAtIndex:i];
            
            if([item source] == source){
                
                id imageTask = [tasks objectAtIndex:i];
                
                [imageTask setLoading:NO];
                
                [tasks removeObjectAtIndex:i];
                
                c --;
            }
            else{
                i ++;
            }
        }
        
        if([tasks count] == 0){
            [_imageTasks removeObjectForKey:key];
            id httpTask = [_httpTasks objectForKey:key];
            if(httpTask){
                [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:httpTask];
                [_httpTasks removeObjectForKey:key];
            }
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
    
    NSString * key = [[httpTask userInfo] valueForKey:@"key"];
    
    if(key){
        
        NSMutableArray * imageTasks = [_imageTasks objectForKey:key];
        
        if(imageTasks){
            
            for(id imageTask in imageTasks){
                [imageTask setLoading:NO];
                [imageTask setImage:nil isLocal:NO];
            }
            
            [_imageTasks removeObjectForKey:key];
            [_httpTasks removeObjectForKey:key];
        }
        
    }
    
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    NSString * key = [[httpTask userInfo] valueForKey:@"key"];
    
    if(key){
        
        UIImage * image = [UIImage imageWithContentsOfFile:[httpTask responseBody]];
        
        if(image){
            
            if(_imageCached == nil){
                _imageCached = [[NSMutableDictionary alloc] init];
            }
            
            [_imageCached setObject:image forKey:key];
        }
        
        
        NSMutableArray * imageTasks = [_imageTasks objectForKey:key];
        
        if(imageTasks){
            
            for(id imageTask in imageTasks){
                [imageTask setLoading:NO];
                [imageTask setImage:image isLocal:NO];
            }
            
            [_imageTasks removeObjectForKey:key];
            [_httpTasks removeObjectForKey:key];
        }
        
    }
    
}

@end
