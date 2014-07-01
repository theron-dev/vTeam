//
//  VTHttpTask.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHttpTask.h"

#import "VTJSON.h"

#import "NSData+VTMD5String.h"
#import "NSFileManager+VTMD5String.h"
#import "NSString+VTMD5String.h"

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
@synthesize userInfo = _userInfo;
@synthesize allowResume = _allowResume;
@synthesize beginLength = _beginLength;
@synthesize contentType = _contentType;
@synthesize responseEncoding = _responseEncoding;
@synthesize allowWillRequest = _allowWillRequest;
@synthesize allowStatusCode302 = _allowStatusCode302;
@synthesize responseUUID = _responseUUID;
@synthesize reuseFilePath = _reuseFilePath;

-(void) dealloc{
    [_userInfo release];
    [_request release];
    [_responseBody release];
    [_response release];
    [_contentType release];
    [_responseUUID release];
    [_reuseFilePath release];
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
        
        if(_reuseFilePath){
            self.responseBody = _reuseFilePath;
        }
        else {
            self.responseBody = [VTHttpTask localResourcePathForURL:url];
        }
        
        BOOL isFileExist = [fileManager fileExistsAtPath:_responseBody];
        
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
        
        if(isFileExist && ! _forceUpdateResource){
            
            NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:_request.URL cachePolicy:_request.cachePolicy timeoutInterval:_request.timeoutInterval];

            [req setAllHTTPHeaderFields:_request.allHTTPHeaderFields];
            
            NSDictionary * attr = [fileManager attributesOfItemAtPath:_responseBody error:nil];
            
            NSDate * date = [attr fileModificationDate];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
            
            NSString * modified = [df stringFromDate:date];
            
            [df release];
            
            [req setValue:modified forHTTPHeaderField:@"If-Modified-Since"];
            
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
        FILE * f = fopen([t UTF8String], "a");
        if(f){
            fwrite([data bytes], 1, [data length], f);
            fclose(f);
        }
    }
}

-(void) doBackgroundLoaded{
    if(_responseType == VTHttpTaskResponseTypeString && _responseBody){
        
        self.responseUUID = [_responseBody vtMD5String];
        
        if([[self.contentType lowercaseString] rangeOfString:@"charset=gbk"].location != NSNotFound || _responseEncoding == VTHttpTaskResponseEncodingGBK){
            self.responseBody = [[[NSString alloc] initWithData:_responseBody encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] autorelease];
        }
        else{
            self.responseBody = [[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding] autorelease];
        }
    }
    else if(_responseType == VTHttpTaskResponseTypeJSON && _responseBody){
        
        self.responseUUID = [_responseBody vtMD5String];
        
        NSString * s = nil;
        if([[self.contentType lowercaseString] rangeOfString:@"charset=gbk"].location != NSNotFound || _responseEncoding == VTHttpTaskResponseEncodingGBK){
            s = [[[NSString alloc] initWithData:_responseBody encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] autorelease];
        }
        else{
            s = [[[NSString alloc] initWithData:_responseBody encoding:NSUTF8StringEncoding] autorelease];
        }

        self.responseBody = s ? [VTJSON decodeText:s] : nil;
        
        //if(![_responseBody isKindOfClass:[NSDictionary class]]){
            NSLog(@"%@",s);
        //}
    }
    else if(_responseType == VTHttpTaskResponseTypeResource){
        
        NSString * t = [_responseBody stringByAppendingPathExtension:@"tmp"];
        
        BOOL saveFile = NO;
        BOOL removeFile = NO;
        
        if(self.allowResume){
            if(_contentLength == _downloadLength){

                saveFile = YES;
                
            }
        }
        else if( !self.allowCheckContentLength
           || _contentLength == 0 || _contentLength == _downloadLength){
            
            saveFile = YES;
            
            
        }
        else{
            removeFile = YES;
        }
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        if(saveFile){
            
            [fileManager removeItemAtPath:_responseBody error:nil];
            [fileManager moveItemAtPath:t toPath:_responseBody error:nil];
            
            self.responseUUID = [fileManager vtMD5StringAtPath:_responseBody];
            
            NSString * modified = [[self.response allHeaderFields] valueForKey:@"Last-Modified"];
            
            if(modified){
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                
                df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
                
                NSDate * date = [df dateFromString:modified];
                
                [df release];
                
                NSDictionary * attr = [fileManager attributesOfItemAtPath:_responseBody error:nil];
                
                if(attr){
                    
                    NSMutableDictionary * mattr = [NSMutableDictionary dictionaryWithDictionary:attr];
                    
                    [mattr setValue:date forKeyPath:NSFileModificationDate];
                    
                    [fileManager setAttributes:mattr ofItemAtPath:_responseBody error:nil];
                    
                }
                
            }
            
        }
        else if(removeFile){
            [fileManager removeItemAtPath:t error:nil];
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
            FILE * f = fopen([t UTF8String], "w");
            if(f){
                fclose(f);
            }
        }
    }
}
    
+(BOOL) hasResourceForURL:(NSURL *) url{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self localResourcePathForURL:url] isDirectory:nil];
}
    
+(BOOL) isLoadingResourceForURL:(NSURL *) url{
    return [[NSFileManager defaultManager] fileExistsAtPath:[[self localResourcePathForURL:url] stringByAppendingPathExtension:@"tmp"] isDirectory:nil];
}
    
+(NSString *) localResourcePathForURL:(NSURL *) url{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[[url absoluteString] vtMD5String]];
}

@end
