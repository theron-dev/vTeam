//
//  NSString+VTBASE64Decode.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+VTBASE64Decode.h"

#include "hconfig.h"
#include "hbase64.h"

@implementation NSString (VTBASE64Decode)

-(NSData *) vtBASE64Decode{
    
    InvokeTickBegin
    huint32 size = (huint32) [self length] * 3 / 4 + 1;
    hbuffer_t buf = buffer_alloc(MAX(size, 512), 1024);
    
    hbase64_decode([self UTF8String], buf);
    
    NSData * rs = [NSData dataWithBytes:buffer_data(buf) length:buffer_length(buf)];
    
    buffer_dealloc(buf);
    
    return rs;
}

@end
