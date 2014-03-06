//
//  VTUnZip.m
//  vTeam
//
//  Created by zhang hailong on 13-6-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTUnZip.h"

#include "unzip.h"

NSString * kVTUnZipFileName = @"kVTUnZipFileName";
NSString * kVTUnZipFileSize = @"kVTUnZipFileSize";

@interface VTUnZip(){
    unzFile _zFile;
    BOOL _isToFirst;
}

@end

@implementation VTUnZip

-(id) initWithZipFile:(NSString *) filePath{
    if((self = [super init])){
        _zFile = unzOpen([filePath UTF8String]);
        if(!_zFile){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    if(_zFile){
        unzClose(_zFile);
    }
    [super dealloc];
}

-(BOOL) nextZipEntity{
    if(!_isToFirst){
        _isToFirst = YES;
        return UNZ_OK == unzGoToFirstFile(_zFile);
    }
    return UNZ_OK == unzGoToNextFile(_zFile);
}

-(NSDictionary *) entityAttributes{
    
    unz_file_info info;
    char fileName[PATH_MAX];
    
    if(UNZ_OK == unzGetCurrentFileInfo(_zFile, &info, fileName, sizeof(fileName), NULL, 0, NULL, 0)){
        
        return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithCString:fileName encoding:NSUTF8StringEncoding],kVTUnZipFileName
                , [NSNumber numberWithLong:info.uncompressed_size],kVTUnZipFileSize
                , nil];
    }
    
    return nil;
}

-(NSString *) entityFileName{
    unz_file_info info;
    char fileName[PATH_MAX];
    
    if(UNZ_OK == unzGetCurrentFileInfo(_zFile, &info, fileName, sizeof(fileName), NULL, 0, NULL, 0)){
        
        return [NSString stringWithCString:fileName encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

-(NSUInteger) entityFileSize{
    
    unz_file_info info;
    
    if(UNZ_OK == unzGetCurrentFileInfo(_zFile, &info, NULL, 0, NULL, 0, NULL, 0)){
        return info.uncompressed_size;
    }
    
    return 0;
}

-(BOOL) openZipEntity{
    return UNZ_OK == unzOpenCurrentFile(_zFile);
}

-(BOOL) closeZipEntity{
    return UNZ_OK == unzCloseCurrentFile(_zFile);
}

-(NSUInteger) read:(void *) buffer length:(NSUInteger) length{
    return unzReadCurrentFile(_zFile, buffer, (unsigned) length);
}

-(void) unZipToDirectory:(NSString *) directory{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    char sbuf[102400];
    int len;
    while([self nextZipEntity]){
        NSString * fileName = [self entityFileName];
        if([fileName hasSuffix:@"/"]){
            [fileManager createDirectoryAtPath:[directory stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else{
            if([self openZipEntity]){
                FILE * f = fopen([[directory stringByAppendingPathComponent:fileName] UTF8String], "w");
                if(f){
                    while((len = (int) [self read:sbuf length:sizeof(sbuf)]) >0){
                        fwrite(sbuf, 1, len, f);
                    }
                    fclose(f);
                }
                [self closeZipEntity];
            }
        }
    }
}

@end

@implementation NSData (VTUnZip)

+(id) dataWithZipFile:(NSString *) filePath fileName:(NSString *) fileName{
    NSData * d = nil;
    VTUnZip * unZip = [[VTUnZip alloc] initWithZipFile:filePath];
    while([unZip nextZipEntity]){
        
        NSDictionary * attributes = [unZip entityAttributes];
        
        NSString * name = [attributes valueForKey:kVTUnZipFileName];
        
        if([name isEqualToString:fileName]){
            
            if([unZip openZipEntity]){
                
                long fileSize = [[attributes valueForKey:kVTUnZipFileSize] longValue];
                
                NSMutableData * md = [NSMutableData dataWithLength:fileSize];
                
                if([unZip read:[md mutableBytes] length:fileSize] == fileSize){
                    d = md;
                }
                
                [unZip closeZipEntity];
            }
            
            break;
        }
        
    }
    [unZip release];
    return d;
}

@end

@implementation NSString (VTUnZip)

+(id) stringWithZipFile:(NSString *) filePath fileName:(NSString *) fileName{
    NSData * data = [NSData dataWithZipFile:filePath fileName:fileName];
    if(data){
        return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    return nil;
}

@end
