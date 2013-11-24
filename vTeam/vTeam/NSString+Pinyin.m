//
//  NSString+Pinyin.m
//  vTeam
//
//  Created by zhang hailong on 13-11-23.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+Pinyin.h"

#include "hconfig.h"
#include "hpinyin.h"

@implementation NSString (Pinyin)

-(NSString *) pinyinInitials{
    
    if([self length] ){
        
        unichar c = [self characterAtIndex:0];
        
        if( c >> 8 ){
            
            hpinyin_t p = pinyin_find(c, InvokeTickRoot);
            
            if(p && pinyin_count(p, InvokeTickRoot) > 0){
                
                const char * cc = pinyin_get(p, 0, InvokeTickRoot);
                
                if(cc){
                    c = * cc;
                    return [NSString stringWithCharacters:&c length:1];
                }
                
            }
        }
        else{
            return [NSString stringWithCharacters:&c length:1];
        }
    }
    
    return nil;
}

@end
