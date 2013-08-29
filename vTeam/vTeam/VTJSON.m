//
//  VTJSON.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTJSON.h"

#include "hconfig.h"
#include "hjson.h"
#include "hstr.h"
#include "hbase64.h"

#include <objc/runtime.h>

@interface NSNull(VTJSON)

@end

@implementation NSNull(VTJSON)

-(NSString *) stringValue{
    return nil;
}

-(int) intValue{
    return 0;
}

-(long) longValue{
    return 0;
}

-(long long) longLongValue{
    return 0;
}

-(float) floatValue{
    return 0.0f;
}

-(double) doubleValue{
    return 0.0;
}

-(BOOL) boolValue{
    return NO;
}

-(NSInteger) length{
    return 0;
}

@end


static hany VTJSON_object_new(struct _hjson_t * json,InvokeTickDeclare){
    return [NSMutableDictionary dictionary];
}

static void VTJSON_object_put(struct _hjson_t * json,hany object,hcchar * key,hany value,InvokeTickDeclare){
    [(id) object setValue:(id) value forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
}

static hany VTJSON_array_new(struct _hjson_t * json,InvokeTickDeclare){
    return [NSMutableArray array];
}

static void VTJSON_array_add(struct _hjson_t * json,hany array,hany value,InvokeTickDeclare){
    return [(id) array addObject:(id) value];
}

static hany VTJSON_number(struct _hjson_t * json,hcchar * value,InvokeTickDeclare){
    if(str_exist(value, ".") || str_exist(value, "e")){
		return [NSNumber numberWithDouble:atof(value)];
	}
	else{
        return [NSNumber numberWithLongLong:atoll(value)];
	}
}

static hany VTJSON_string(struct _hjson_t * json,hcchar * value,struct _buffer_t * base64_buffer,InvokeTickDeclare){
    return [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
}

static hany VTJSON_boolean(struct _hjson_t * json,hbool value,InvokeTickDeclare){
    return [NSNumber numberWithBool:value ? YES:NO];
}

static hany VTJSON_null(struct _hjson_t * json,InvokeTickDeclare){
    return [NSNull null];
}

static void VTJSON_object_dealloc(struct _hjson_t * json,hany object,InvokeTickDeclare){
    
}

static hjson_t VTJSONDecode = {
    VTJSON_object_new,
    VTJSON_object_put,
    VTJSON_array_new,
    VTJSON_array_add,
    VTJSON_number,
    VTJSON_string,
    VTJSON_boolean,
    VTJSON_null,
    VTJSON_object_dealloc
};

@implementation VTJSON

+(id) decodeText:(NSString *) text{
    return hjson_decode(&VTJSONDecode, [text UTF8String], InvokeTickRoot);
}

+(NSString *) encodeObject:(id) data{
    NSMutableString * ret = [NSMutableString stringWithCapacity:100];
    if([data isKindOfClass:[NSNumber class]]){
        [ret appendFormat:@"%@",data];
    }
    else if([data isKindOfClass:[NSString class]]){
        [ret appendString:@"\""];
        NSRange range = {0,1};
        NSString * charStr = nil;
        for(;range.location < [data length];range.location ++){
            charStr = [data substringWithRange:range];
            if([charStr isEqualToString:@"\""]){
                [ret appendString:@"\\\""];
            }
            else if([charStr isEqualToString:@"\n"]){
                [ret appendString:@"\\n"];
            }
            else if([charStr isEqualToString:@"\r"]){
                [ret appendString:@"\\r"];
            }
            else if([charStr isEqualToString:@"\t"]){
                [ret appendString:@"\\t"];
            }
            else if([charStr isEqualToString:@"\\"]){
                [ret appendString:@"\\\\"];
            }
            else{
                [ret appendString:charStr];
            }
        }
        [ret appendString:@"\""];
    }
    else if([data isKindOfClass:[NSDictionary class]]){
        [ret appendString:@"{"];
        
        NSEnumerator * keyEnum = [data keyEnumerator];
        NSString * key;
        BOOL first = YES;
        while((key = [keyEnum nextObject])){
            
            id value = [data valueForKey:key];
            
            if(value == nil || [value isKindOfClass:[NSNull class]]){
                continue;
            }
            
            if(first){
                first = NO;
            }
            else{
                [ret appendString:@","];
            }
            [ret appendFormat:@"\"%@\":",key];
            [ret appendString:[VTJSON encodeObject:value]];
        }
        
        [ret appendString:@"}"];
    }
    else if([data isKindOfClass:[NSArray class]]){
        [ret appendString:@"["];
        BOOL first =YES;
        for(id item in data){
            if(first){
                first = NO;
            }
            else{
                [ret appendString:@","];
            }
            [ret appendString:[VTJSON encodeObject:item]];
        }
        [ret appendString:@"]"];
    }
    else if([data isKindOfClass:[NSNull class]]){
        [ret appendString:@"null"];
    }
    else if(data){
        [ret appendString:@"{"];
        BOOL first = YES;
        {
            Class clazz = [data class];
            objc_property_t * prop;
            unsigned int c;
            while(clazz && clazz != [NSObject class]){
                
                prop = class_copyPropertyList(clazz, &c);
                
                for(int i=0;i<c;i++){
                    NSString * key = [NSString stringWithCString:property_getName(prop[i]) encoding:NSUTF8StringEncoding];
                    id value = nil;
                    
                    @try {
                        value = [data valueForKey:key];
                    }
                    @catch (NSException *exception) {
                        value = nil;
                    }
                    
                    if(value == nil || [value isKindOfClass:[NSNull class]]){
                        continue;
                    }
                    
                    if(first){
                        first = NO;
                    }
                    else{
                        [ret appendString:@","];
                    }
                    [ret appendFormat:@"\"%@\":",key];
                    [ret appendString:[VTJSON encodeObject:value]];
                    
                }
                
                free(prop);
                
                clazz = class_getSuperclass(clazz);
            }
        }
        [ret appendString:@"}"];
    }
    else{
        [ret appendString:@"null"];
    }
    
    return ret;
}

@end
