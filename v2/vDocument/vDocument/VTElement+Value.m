//
//  VTElement+Value.m
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTElement+Value.h"

@implementation VTElement (Value)


-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *) defaultValue{
    
    NSString * v = [self attributeValueForKey:key];
    
    if(v){
        return v;
    }
    
    return defaultValue;
}

-(NSString *) stringValueForKey:(NSString *) key{
    return [self stringValueForKey:key defaultValue:nil];
}

-(CGFloat) floatValueForKey:(NSString *) key defaultValue:(CGFloat) defaultValue{
    
    NSString * v = [self stringValueForKey:key];
    
    if(v){
        return [v floatValue];
    }
    
    return defaultValue;
}

-(CGFloat) floatValueForKey:(NSString *) key{
    return [self floatValueForKey:key defaultValue:0];
}

-(CGFloat) floatValueForKey:(NSString *)key of:(CGFloat) of defaultValue:(CGFloat)defaultValue{
   
    NSString * v = [self stringValueForKey:key];
    
    if(v){
        
        if([v isEqualToString:@"auto"]){
            return MAXFLOAT;
        }
        
        NSUInteger length = [v length];
        
        NSRange r = [v rangeOfString:@"%"];
        
        if(r.location != NSNotFound){
            
            if(r.location + r.length == length){
                return [v floatValue] * of * 0.01;
            }
            else {
                return [[v substringToIndex:r.location] floatValue] * of * 0.001 + [[v substringFromIndex:r.location + r.length] floatValue];
            }
            
        }
        else {
            return [v floatValue];
        }
        
    }
    
    return defaultValue;
}

-(CGFloat) floatValueForKey:(NSString *)key of:(CGFloat) of{
    return [self floatValueForKey:key of:of defaultValue:0];
}

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL) defaultValue{
    NSString * v = [self stringValueForKey:key defaultValue:nil];
    if(v){
        return ! ([v isEqualToString:@"false"] || [v isEqualToString:@"0"] || [v isEqualToString:@""] || [v isEqualToString:@"no"]);
    }
    return defaultValue;
}

@end
