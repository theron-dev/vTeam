//
//  NSData+VTMD5String.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSData+VTMD5String.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (VTMD5String)

-(NSString *) vtMD5String{
    unsigned char md[16];
    CC_MD5([self bytes], (unsigned int) [self length], md);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            md[0], md[1], md[2], md[3],
            md[4], md[5], md[6], md[7],
            md[8], md[9], md[10], md[11],
            md[12], md[13], md[14], md[15]
            ];
}


@end
