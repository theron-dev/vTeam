//
//  NSFileManager+VTMD5String.m
//  vTeam
//
//  Created by zhang hailong on 14-2-26.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "NSFileManager+VTMD5String.h"

#import <CommonCrypto/CommonCrypto.h>


@implementation NSFileManager (VTMD5String)

-(NSString *) vtMD5StringAtPath:(NSString *) filePath{
    
    if([self fileExistsAtPath:filePath]){
        
        char buffer[10240];
        ssize_t length;
        unsigned char md[32];
        
        CC_MD5_CTX ctx;
        
        CC_MD5_Init(& ctx);
        
        FILE * f = fopen([filePath UTF8String], "r");
        
        if(f){
        
            while ((length = fread(buffer, 1, sizeof(buffer), f)) >0 || (length<0 && errno==EINTR)) {
                
                if(length > 0){
                    
                    CC_MD5_Update(& ctx, buffer, (unsigned int) length);
                    
                }
                
            }
            
            fclose(f);
            
            CC_MD5_Final(md, &ctx);
            
            return [NSString stringWithFormat:
                    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    md[0], md[1], md[2], md[3],
                    md[4], md[5], md[6], md[7],
                    md[8], md[9], md[10], md[11],
                    md[12], md[13], md[14], md[15]
                    ];
        }
        
        
    }
    
    return nil;
}

@end
