//
//  VTHttpTask.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>

typedef enum {
    VTHttpTaskResponseTypeNone,VTHttpTaskResponseTypeString,VTHttpTaskResponseTypeJSON,VTHttpTaskResponseTypeResource
} VTHttpTaskResponseType;

typedef enum {
    VTHttpTaskResponseEncodingNone,VTHttpTaskResponseEncodingGBK
} VTHttpTaskResponseEncoding;

@protocol IVTHttpTaskDelegate

@optional

-(void) vtHttpTaskWillRequest:(id) httpTask;

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error;

-(void) vtHttpTaskDidLoaded:(id) httpTask;

-(void) vtHttpTaskDidLoading:(id) httpTask;

-(void) vtHttpTaskDidResponse:(id) httpTask;

-(void) vtHttpTask:(id) httpTask didReceiveData:(NSData *) data bytesDownload:(unsigned long long)bytesDownload totalBytes:(unsigned long long) totalBytes;

-(void) vtHttpTask:(id) httpTask didSendBodyDataBytesWritten:(unsigned long long) bytesWritten totalBytesWritten:(unsigned long long) totalBytesWritten;

@end

@protocol IVTHttpTask<IVTTask>

@property(retain) NSURLRequest * request;
@property(assign) id delegate;
@property(retain) id responseBody;
@property(assign) VTHttpTaskResponseEncoding responseEncoding;
@property(assign) VTHttpTaskResponseType responseType;
@property(retain) NSHTTPURLResponse * response;
@property(retain) id userInfo;
@property(assign,getter = isAllowWillRequest) BOOL allowWillRequest;

-(NSURLRequest *) doWillRequeset;

-(void) doFailError:(NSError *) error;

-(void) doLoaded;

-(void) doLoading;

-(void) doResponse;

-(void) doReceiveData:(NSData *) data;

-(void) doSendBodyDataBytesWritten:(int) bytesWritten totalBytesWritten:(int) totalBytesWritten;

-(void) doBackgroundReceiveData:(NSData *) data;

-(void) doBackgroundLoaded;

-(void) doBackgroundResponse:(NSHTTPURLResponse *) response;

@end

@protocol IVTHttpAPITask <IVTHttpTask>


@end

@protocol IVTHttpUploadTask <IVTHttpTask>


@end

@protocol IVTHttpResourceTask <IVTHttpTask>

@property(assign) BOOL allowCheckContentLength;
@property(assign) BOOL forceUpdateResource;
@property(assign) BOOL onlyLocalResource;
@property(assign) BOOL allowResume;

@end

@interface VTHttpTask : VTTask<IVTHttpTask,IVTHttpAPITask,IVTHttpUploadTask,IVTHttpResourceTask>

@end


