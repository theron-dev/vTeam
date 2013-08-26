//
//  VTHttpTask.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHttpTask.h"

#import "VTJSON.h"

#include "hconfig.h"
#include "md5.h"
#include "htime.h"
#include "hfile.h"

@interface VTHttpTask()

@property(assign) unsigned long long contentLength;
@property(assign) unsigned long long downloadLength;
@property(assign) unsigned long long beginLength;

@property(retain) NSString * contentType;

@end

@implementation VTHttpTask

@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize responseBody = _responseBody;
@synthesize responseType = _responseType;
@synthesize response = _response;
@synthesize contentLength = _contentLength;
@synthesize downloadLength = _downloadLength;
@synthesize allowCheckContentLength = _allowCheckContentLength;
@synthesize forceUpdateResource = _forceUpdateResource;
@synthesize onlyLocalResource = _onlyLocalResource;
@synthesize userInfo = _userInfo;
@synthesize allowResume = _allowResume;
@synthesize beginLength = _beginLength;
@synthesize contentType = _contentType;
@synthesize responseEncoding = _responseEncoding;
@synthesize allowWillRequest = _allowWillRequest;
@synthesize allowStatusCode302 = _allowStatusCode302;

-(void) dealloc{
    [_userInfo release];
    [_request release];
    [_responseBody release];
    [_response release];
    [_contentType release];
    [super dealloc];
}

-(NSURLRequest *) doWillRequeset{
    
    if([_delegate respondsToSelector:@selector(vtHttpTaskWillRequest:)]){
        [_delegate vtHttpTaskWillRequest:self];
    }
    
    if(_responseType == VTHttpTaskResponseTypeResource){
        
        NSURL * url = _request.URL;
        NSFileManager * fileManager = [NSFileManager defaultManager];

        
        if([url isFileURL]){
            
            self.responseBody = [url path];
                        
            if([fileManager fileExistsAtPath:_responseBody]){
                [self doLoaded];
            }
            else{
                [self doFailError:[NSError errorWithDomain:@"VTHttpTask" code:-4 userInfo:[NSDictionary dictionaryWithObject:@"not found file" forKey:NSLocalizedDescriptionKey]]];
            }
            
            return nil;
        }
        
        md5_state_t md5;
        md5_byte_t digest[16];
        int i;
        
        md5_init(&md5);
        
        NSData * bytes = [[url absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
        
        md5_append(&md5, [bytes bytes], [bytes length]);
        
        md5_finish(&md5, digest);
        
        NSMutableString * md5String = [NSMutableString stringWithCapacity:32];
        
        for(i=0;i<16;i++){
            [md5String appendFormat:@"%02x",digest[i]];
        }
       
        self.responseBody = [NSTemporaryDirectory() stringByAppendingPathComponent:md5String];
        
        BOOL isFileExist = [fileManager fileExistsAtPath:_responseBody];
        
        if(_onlyLocalResource){
            
            if([fileManager fileExistsAtPath:_responseBody]){
                [self doLoaded];
            }
            else{
                [self doFailError:[NSError errorWithDomain:@"VTHttpTask" code:-4 userInfo:[NSDictionary dictionaryWithObject:@"not found file" forKey:NSLocalizedDescriptionKey]]];
            }
            
            return nil;
        }
        
        if(!_forceUpdateResource && isFileExist){
            
            [self doLoaded];

            return nil;
        }
        
        if(self.allowResume){
            
            NSString * tmpFilePath = [_responseBody stringByAppendingPathExtension:@"tmp"];
            
            if([fileManager fileExistsAtPath:tmpFilePath]){
                
                NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:_request.URL cachePolicy:_request.cachePolicy timeoutInterval:_request.timeoutInterval];
                
                _beginLength = [[fileManager attributesOfItemAtPath:tmpFilePath error:nil] fileSize];
                
                [req setValue:[NSString stringWithFormat:@"bytes=%llu-",_beginLength] forHTTPHeaderField:@"Range"];
                
                return req;
            }
            
        }
        
        if(isFileExist){
            
            NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:_request.URL cachePolicy:_request.cachePolicy timeoutInterval:_request.timeoutInterval];

            [req setAllHTTPHeaderFields:_request.allHTTPHeaderFields];
            
            time_t t = file_last_modified_get([_responseBody UTF8String]);
            char d[128] = "";
            
            time_to_gmt_str(&t, d, sizeof(d));
            
            [req setValue:[NSString stringWithCString:d encoding:NSUTF8StringEncoding] forHTTPHeaderField:@"If-Modified-Since"];
            
            return req;
        }

        
        return _request;
    }
    
    return _request;
}

-(void) doFailError:(NSError *) error{
    if([_delegate respondsToSelector:@selector(vtHttpTask:didFailError:)]){
        [_delegate vtHttpTask:self didFailError:error];
    }
}

-(void) doLoading{
    if([_delegate respondsToSelector:@selector(vtHttpTaskDidLoading:)]){
        [_delegate vtHttpTaskDidLoading:self];
    }
}

-(void) doLoaded{
    if(_responseType == VTHttpTaskResponseTypeResource){
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:_responseBody]){
            if([_delegate respondsToSelector:@selector(vtHttpTask:didFailError:)]){
                [_delegate vtHttpTask:self didFailError:[NSError errorWithDomain:@"VTHttpTask" code:-4 userInfo:[NSDictionary dictionaryWithObject:@"not found file" forKey:NSLocalizedDescriptionKey]]];
            }
            return;
        }
    }
    if([_delegate respondsToSelector:@selector(vtHttpTaskDidLoaded:)]){
        [_delegate vtHttpTaskDidLoaded:self];
    }
}

-(BOOL) hasDoResponse{
    return [_delegate respondsToSelector:@selector(vtHttpTaskDidResponse:)];
}

-(void) doResponse{
    if([_delegate respondsToSelector:@selector(vtHttpTaskDidResponse:)]){
        [_delegate vtHttpTaskDidResponse:self];
    }
}

-(BOOL) hasDoReceiveData{
    return [_delegate respondsToSelector:@selector(vtHttpTask:didReceiveData:bytesDownload:totalBytes:)];
}

-(void) doReceiveData:(NSData *) data{
    if([_delegate respondsToSelector:@selector(vtHttpTask:didReceiveData:bytesDownload:totalBytes:)]){
        [_delegate vtHttpTask:self didReceiveData:data bytesDownload:_downloadLength + _beginLength totalBytes:_contentLength + _beginLength];
    }
}


-(void) doSendBodyDataBytesWritten:(int) bytesWritten totalBytesWritten:(int) totalBytesWritten{
    if([_delegate respondsToSelector:@selector(vtHttpTask:didSendBodyDataBytesWritten:totalBytesWritten:)]){
        [_delegate vtHttpTask:self didSendBodyDataBytesWritten:bytesWritten totalBytesWritten:totalBytesWritten];
    }
}

-(BOOL) hasDoSendBodyDataBytes{
    return [_delegate respondsToSelector:@selector(vtHttpTask:didSendBodyDataBytesWritten:totalBytesWritten:)];
}

-(void) doBackgroundReceiveData:(NSData *) data{
    _downloadLength += [data length];
    if(_responseType == VTHttpTaskResponseTypeJSON || _responseType == VTHttpTaskResponseTypeString){
        [_responseBody appendData:data];
    }
    else if(_responseType == VTHttpTaskResponseTypeResource){
        NSString * t = [_responseBody stringByAppendingPathExtension:@"tmp"];
        FILE * f = fopen([t UTF8String], "ab");
        if(f){
            fwrite([data bytes], 1, [data length], f);
            fclose(f);
        }
    }
}

-(void) doBackgroundLoaded{
    if(_responseType == VTHttpTaskResponseTypeString && _responseBody){
        if([[self.contentType lowercaseString] rangeOfString:@"charset=gbk"].location != NSNotFound || _responseEncoding == VTHttpTaskResponseEncodingGBK){
            self.responseBody = [[[NSString alloc] initWithData:_responseBody encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] autorelease];
        }
        else{
            self.responseBody = [[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding] autorelease];
        }
    }
    else if(_responseType == VTHttpTaskResponseTypeJSON && _responseBody){
        NSString * s = nil;
        if([[self.contentType lowercaseString] rangeOfString:@"charset=gbk"].location != NSNotFound || _responseEncoding == VTHttpTaskResponseEncodingGBK){
            s = [[[NSString alloc] initWithData:_responseBody encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] autorelease];
        }
        else{
            s = [[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding] autorelease];
        }
        self.responseBody = s ? [VTJSON decodeText:s] : nil;
    }
    else if(_responseType == VTHttpTaskResponseTypeResource){
        NSString * t = [_responseBody stringByAppendingPathExtension:@"tmp"];
        if(self.allowResume){
            if(_contentLength == _downloadLength){
                file_rename([t UTF8String], [_responseBody UTF8String]);
            }
        }
        else if(self.allowCheckContentLength 
           || _contentLength == 0 || _contentLength == _downloadLength){
            file_rename([t UTF8String], [_responseBody UTF8String]);
        }
        else{
            [[NSFileManager defaultManager] removeItemAtPath:t error:nil];
        }
    }
}

-(void) doBackgroundResponse:(NSHTTPURLResponse *) response{
    self.response = response;
    self.contentLength = [[[response allHeaderFields] valueForKey:@"Content-Length"] intValue];
    self.contentType =[[response allHeaderFields] valueForKey:@"Content-Type"];
    
    if(_responseType == VTHttpTaskResponseTypeJSON || _responseType == VTHttpTaskResponseTypeString){
        self.responseBody = [NSMutableData dataWithCapacity:4];
    }
    else if(_responseType == VTHttpTaskResponseTypeResource){
        if(_beginLength == 0){
            NSString * t = [_responseBody stringByAppendingPathExtension:@"tmp"];
            FILE * f = fopen([t UTF8String], "wb");
            if(f){
                fclose(f);
            }
        }
    }
}

@end
