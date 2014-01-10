//
//  NSURL+QueryValue.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSURL+QueryValue.h"

#include <objc/runtime.h>

@implementation NSURL (QueryValue)

-(NSDictionary *) queryValues{
    NSMutableDictionary * d = [NSMutableDictionary dictionaryWithCapacity:4];
    NSArray * items = [[self query] componentsSeparatedByString:@"&"];
    for(NSString * item in items){
        NSArray * kv = [item componentsSeparatedByString:@"="];
        if([kv count] >1){
            [d setValue:[NSURL decodeQueryValue:[kv objectAtIndex:1]] forKey:[kv objectAtIndex:0]];
        }
    }
    return d;
}

+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryValues:(id) queryValues{
    NSRange r = [URLString rangeOfString:@"?"];
    NSMutableString * ms = [NSMutableString stringWithCapacity:64];
    BOOL isFirst = NO;
    if(r.location == NSNotFound){
        [ms appendString:@"?"];
        isFirst = YES;
    }
    else if(r.location == [URLString length] -1){
        isFirst = YES;
    }
    
    if([queryValues isKindOfClass:[NSDictionary class]]){
        for(NSString * key in queryValues){
            if(isFirst){
                isFirst = NO;
            }
            else{
                [ms appendString:@"&"];
            }
            id v = [queryValues valueForKey:key];
            if(![v isKindOfClass:[NSString class]]){
                v = [NSString stringWithFormat:@"%@",v];
            }
            [ms appendFormat:@"%@=%@",key ,[NSURL encodeQueryValue:v]];
        }
    }
    else if(queryValues){
        Class clazz = [queryValues class];
        while(clazz != [NSObject class]){
            unsigned c = 0;
            objc_property_t * prop = class_copyPropertyList(clazz, &c);
            objc_property_t * p = prop;
            
            while(c >0){
                
                NSString * key = [NSString stringWithCString:property_getName(*p)
                                                    encoding:NSUTF8StringEncoding];
                
                id v = [queryValues valueForKey:key];

                if(v == nil){
                    c --;
                    p ++;
                    continue;
                }
                
                if(isFirst){
                    isFirst = NO;
                }
                else{
                    [ms appendString:@"&"];
                }
                
                if(![v isKindOfClass:[NSString class]]){
                    v = [NSString stringWithFormat:@"%@",v];
                }
                [ms appendFormat:@"%@=%@",key ,[NSURL encodeQueryValue:v]];
                
                c --;
                p ++;
            }
            free(prop);
            
            clazz = class_getSuperclass(clazz);
        }
    }
    
    return [NSURL URLWithString:[URLString stringByAppendingString:ms] relativeToURL:baseURL];
}

+ (id)URLWithString:(NSString *)URLString queryValues:(id) queryValues{
    return [NSURL URLWithString:URLString relativeToURL:nil queryValues:queryValues];
}

+ (NSString *) decodeQueryValue:(NSString *) queryValue{
    NSMutableData * md = [NSMutableData dataWithCapacity:64];
    unsigned char * p = (unsigned char *) [queryValue UTF8String];
    unsigned int c;
    char sx[4];
    while(p && *p != '\0'){
        
        if(*p == '+'){
            [md appendBytes:" " length:1];
        }
        else if(*p == '%'){
            c = 0;
            sx[0] = p[1];
            sx[1] = p[2];
            sx[2] = 0;
            
            sscanf(sx, "%02x",&c);
            
            if(c){
                [md appendBytes:&c length:1];
            }
            
            p += 2;
        }
        else{
            [md appendBytes:p length:1];
        }
        
        p++;
    }
    return [[[NSString alloc] initWithData:md encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *) encodeQueryValue:(NSString *) queryValue{
    NSMutableString * ms = [NSMutableString stringWithCapacity:64];
    unsigned char * p = (unsigned char *) [queryValue UTF8String];
    while(p && *p != '\0'){
        
        if(*p == ' '){
            [ms appendString:@"+"];
        }
        else if(*p == '.'){
            [ms appendString:@"."];
        }
        else if(*p == '-'){
            [ms appendString:@"-"];
        }
        else if(*p == '_'){
            [ms appendString:@"_"];
        }
        else if((*p >='0' && *p <='9') || (*p >= 'a' && *p <='z') || (*p >= 'A' && *p <='Z')){
            [ms appendFormat:@"%c",*p];
        }
        else{
            [ms appendFormat:@"%%%02X",*p];
        }
        
        p++;
    }
    return ms;
}

+ (NSDictionary *) decodeQuery:(NSString *) query{
    
    NSArray * items = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&?"]];
    
    NSMutableDictionary * queryValues = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for(NSString * item in items){
        
        NSArray * vs = [item componentsSeparatedByString:@"="];
        
        if([vs count] > 1){
            [queryValues setValue:[self decodeQueryValue:[vs objectAtIndex:1]] forKey:[vs objectAtIndex:0]];
        }
        
    }
    
    return queryValues;
}

+ (NSString *) encodeQueryValues:(NSDictionary *) queryValues{
    
    NSMutableString * query = [NSMutableString stringWithCapacity:64];
    
    for(NSString * key in queryValues){
        
        [query appendFormat:@"%@=%@",key,[self encodeQueryValue:[queryValues valueForKey:key]]];
        
    }
    
    return query;
}

-(NSString *) lastPathComponent:(NSInteger) skip{
    NSArray * paths = [self pathComponents];
    NSInteger index = [paths count] - skip -1;
    if(index >=0){
        return [paths objectAtIndex:index];
    }
    return nil;
}

-(NSString *) firstPathComponent{
    NSArray * paths = [self pathComponents];
    
    if([paths count] >0){
        return [paths objectAtIndex:0];
    }
    
    return nil;
}

-(NSString *) firstPathComponent:(NSString *) basePath{
    
    if(![basePath hasSuffix:@"/"]){
        basePath = [basePath stringByAppendingString:@"/"];
    }
    
    NSArray * paths = [self pathComponents:basePath];
    
    if([paths count] >0){
        return [paths objectAtIndex:0];
    }
    
    return nil;
}

-(NSArray *) pathComponents:(NSString *) basePath{
    if(![basePath hasSuffix:@"/"]){
        basePath = [basePath stringByAppendingString:@"/"];
    }
    NSString * path = [self path];
    if([basePath length]< [path length]){
        NSString * path = [[self path] substringFromIndex:[basePath length]];
        return [path pathComponents];
    }
    return nil;
}

@end
