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
    
    NSMutableString * ms = [NSMutableString stringWithCapacity:32];
    
    NSUInteger length = [self length];
    
    for(NSUInteger i = 0;i< length;i++){
        
        unichar uc = [self characterAtIndex:i];
        
        if( uc >> 8){
            
            hpinyin_t p = pinyin_find(uc, InvokeTickRoot);
            
            if(p && pinyin_count(p, InvokeTickRoot) > 0){
                
                const char * cc = pinyin_get(p, 0, InvokeTickRoot);
                
                if(cc){
                    [ms appendFormat:@"%c", * cc];
                }
                else{
                    [ms appendString:@"*"];
                }
                
            }
            else{
                [ms appendString:@"*"];
            }
        }
        else{
            [ms appendString:[NSString stringWithCharacters:& uc length:1]];
        }
        
    }
    
    return ms;
    
}

-(NSString *) pinyinInitialsChar{
   
    if([self length]){
        
        unichar uc = [self characterAtIndex:0];
        
        if( uc >> 8){
            
            hpinyin_t p = pinyin_find(uc, InvokeTickRoot);
            
            if(p && pinyin_count(p, InvokeTickRoot) > 0){
                
                const char * cc = pinyin_get(p, 0, InvokeTickRoot);
                
                if(cc){
                    return [NSString stringWithFormat:@"%c",*cc];
                }

                
            }
            
        }
        else{
            return [NSString stringWithCharacters:& uc length:1];
        }
        
    }
    
    return nil;
}

-(NSString *) pinyin{
    
    NSMutableString * ms = [NSMutableString stringWithCapacity:32];
    
    NSUInteger length = [self length];
    
    for(NSUInteger i = 0;i< length;i++){
        
        unichar uc = [self characterAtIndex:i];
        
        if( uc >> 8){
            
            hpinyin_t p = pinyin_find(uc, InvokeTickRoot);
            
            if(p && pinyin_count(p, InvokeTickRoot) > 0){
                
                const char * cc = pinyin_get(p, 0, InvokeTickRoot);
                
                if(cc){
                    [ms appendFormat:@"%s",cc];
                }
                else{
                    [ms appendString:@"*"];
                }

            }
            else{
                [ms appendString:@"*"];
            }
        }
        else{
            [ms appendString:[NSString stringWithCharacters:& uc length:1]];
        }
        
    }
    
    return ms;
    
}

@end
