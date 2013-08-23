//
//  NSData+GZIP.m
//  vTeam
//
//  Created by zhang hailong on 13-8-23.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSData+GZIP.h"

#include <zlib.h>

#define CHUNK_SIZE 16384

@implementation NSData (GZIP)

-(NSData *) GZIPEncode{
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;
    
    if (deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
    {
        NSMutableData *data = [NSMutableData dataWithLength:CHUNK_SIZE];
        while (stream.avail_out == 0)
        {
            if (stream.total_out >= [data length])
            {
                data.length += CHUNK_SIZE;
            }
            stream.next_out = [data mutableBytes] + stream.total_out;
            stream.avail_out = (uint)([data length] - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        data.length = stream.total_out;
        return data;
    }
    
    return nil;
}

-(NSData *) GZIPDecode{
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)[self length];
    stream.next_in = (Bytef *)[self bytes];
    stream.total_out = 0;
    stream.avail_out = 0;
    
    NSMutableData *data = [NSMutableData dataWithLength: [self length] * 1.5];
    
    if (inflateInit2(&stream, 47) == Z_OK)
    {
        int status = Z_OK;
        while (status == Z_OK)
        {
            if (stream.total_out >= [data length])
            {
                data.length += [self length] * 0.5;
            }
            stream.next_out = [data mutableBytes] + stream.total_out;
            stream.avail_out = (uint)([data length] - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK)
        {
            if (status == Z_STREAM_END)
            {
                data.length = stream.total_out;
                return data;
            }
        }
    }
    
    return nil;
}

@end
