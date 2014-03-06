//
//  NSData+VTBASE64String.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSData+VTBASE64String.h"

#include "hconfig.h"
#include "hbase64.h"

@implementation NSData (VTBASE64String)

-(NSString *) vtBASE64String{
    InvokeTickBegin
    huint32 size = (huint32) [self length] * 4 / 3 + 1;
    hbuffer_t buf = buffer_alloc(MAX(size, 512), 1024);
    
    hbase64_encode((hbyte *)[self bytes], (hint32)[self length], buf);
    
    NSString * rs = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
    
    buffer_dealloc(buf);
    
    return rs;
}

@end
