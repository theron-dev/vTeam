//
//  VTUnZip.h
//  vTeam
//
//  Created by zhang hailong on 13-6-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * kVTUnZipFileName;
extern NSString * kVTUnZipFileSize;


@interface VTUnZip : NSObject

-(id) initWithZipFile:(NSString *) filePath;

-(BOOL) nextZipEntity;

-(NSDictionary *) entityAttributes;

-(NSString *) entityFileName;

-(NSUInteger) entityFileSize;

-(BOOL) openZipEntity;

-(BOOL) closeZipEntity;

-(NSUInteger) read:(void *) buffer length:(NSUInteger) length;

-(void) unZipToDirectory:(NSString *) directory;

@end

@interface NSString(VTUnZip)

+(id) stringWithZipFile:(NSString *) filePath fileName:(NSString *) fileName;

@end

@interface NSData(VTUnZip)

+(id) dataWithZipFile:(NSString *) filePath fileName:(NSString *) fileName;

@end
