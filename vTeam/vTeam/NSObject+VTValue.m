//
//  NSObject+VTValue.m
//  vTeam
//
//  Created by zhang hailong on 13-12-30.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSObject+VTValue.h"

@implementation NSObject (VTValue)

-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *)defalutValue{
    id value = [self objectValueForKey:key];
    if([value isKindOfClass:[NSString class]]){
        return value;
    }
    else if([value respondsToSelector:@selector(stringValue)]){
        value = [value stringValue];
        if(value){
            return value;
        }
    }
    else if(value){
        return [NSString stringWithFormat:@"%@",value];
    }
    return defalutValue;
}

-(NSString *) stringValueForKey:(NSString *) key{
    return [self stringValueForKey:key defaultValue:nil];
}

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(boolValue)]){
        return [value boolValue];
    }
    return defalutValue;
}

-(BOOL) booleanValueForKey:(NSString *) key{
    return [self booleanValueForKey:key defaultValue:NO];
}

-(int) intValueForKey:(NSString *) key defaultValue:(int)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(intValue)]){
        return [value intValue];
    }
    return defalutValue;
}

-(int) intValueForKey:(NSString *) key{
    return [self intValueForKey:key defaultValue:0];
}

-(long) longValueForKey:(NSString *) key defaultValue:(long)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(longValue)]){
        return [value longValue];
    }
    return defalutValue;
}

-(long) longValueForKey:(NSString *) key{
    return [self longValueForKey:key defaultValue:0];
}

-(long long) longLongValueForKey:(NSString *) key defaultValue:(long long)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(longLongValue)]){
        return [value longLongValue];
    }
    return defalutValue;
}

-(long long) longLongValueForKey:(NSString *) key{
    return [self longLongValueForKey:key defaultValue:0];
}

-(float) floatValueForKey:(NSString *) key defaultValue:(float)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(floatValue)]){
        return [value floatValue];
    }
    return defalutValue;
}

-(float) floatValueForKey:(NSString *)key{
    return [self floatValueForKey:key defaultValue:0.0f];
}

-(double) doubleValueForKey:(NSString *) key defaultValue:(double)defalutValue{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(doubleValue)]){
        return [value doubleValue];
    }
    return defalutValue;
}

-(double) doubleValueForKey:(NSString *) key{
    return [self doubleValueForKey:key defaultValue:0.0];
}

-(id) objectValueForKey:(NSString *) key defaultValue:(id)defalutValue{
    
    if([self isKindOfClass:[NSNull class]]
       || [self isKindOfClass:[NSString class]]
       || [self isKindOfClass:[NSNumber class]]
       || key == nil){
        return defalutValue;
    }
    else if([key hasPrefix:@"@"] && [self isKindOfClass:[NSArray class]]){
        if([key isEqualToString:@"@first"]){
            return [self objectValueAtIndex:0];
        }
        else if([key isEqualToString:@"@last"]){
            return [(NSArray *) self lastObject];
        }
        else if([key isEqualToString:@"@joinString"]){
            return [(NSArray *) self componentsJoinedByString:@","];
        }
        else {
            return [self objectValueAtIndex:[[key substringFromIndex:1] intValue]];
        }
    }
    @try {
        return [self valueForKey:key];
    }
    @catch (NSException *exception) {
        
    }
    return defalutValue;
}

-(id) objectValueForKey:(NSString *)key{
    return [self objectValueForKey:key defaultValue:nil];
}

-(NSDictionary *) dictionaryValueForKey:(NSString *)key{
    id v = [self objectValueForKey:key];
    if([v isKindOfClass:[NSDictionary class]]){
        return v;
    }
    return nil;
}

-(NSArray *) arrayValueForKey:(NSString *)key{
    id v = [self objectValueForKey:key];
    if([v isKindOfClass:[NSArray class]]){
        return v;
    }
    return nil;
}


-(NSString *) stringValueForKeyPath:(NSString *) keyPath defaultValue:(NSString *)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value isKindOfClass:[NSString class]]){
        return value;
    }
    else if([value respondsToSelector:@selector(stringValue)]){
        value = [value stringValue];
        if(value){
            return value;
        }
    }
    else if(value){
        return [NSString stringWithFormat:@"%@",value];
    }
    return defalutValue;
}

-(NSString *) stringValueForKeyPath:(NSString *) keyPath{
    return [self stringValueForKeyPath:keyPath defaultValue:nil];
}

-(BOOL) booleanValueForKeyPath:(NSString *) keyPath defaultValue:(BOOL)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(boolValue)]){
        return [value boolValue];
    }
    return defalutValue;
}

-(BOOL) booleanValueForKeyPath:(NSString *)keyPath{
    return [self booleanValueForKeyPath:keyPath defaultValue:NO];
}

-(int) intValueForKeyPath:(NSString *) keyPath defaultValue:(int)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(intValue)]){
        return [value intValue];
    }
    return defalutValue;
}

-(int) intValueForKeyPath:(NSString *) keyPath{
    return [self intValueForKeyPath:keyPath defaultValue:0];
}

-(long) longValueForKeyPath:(NSString *) keyPath defaultValue:(long)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(longValue)]){
        return [value longValue];
    }
    return defalutValue;
}

-(long) longValueForKeyPath:(NSString *) keyPath{
    return [self longValueForKeyPath:keyPath defaultValue:0];
}

-(long long) longLongValueForKeyPath:(NSString *) keyPath defaultValue:(long long)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(longLongValue)]){
        return [value longLongValue];
    }
    return defalutValue;
}

-(long long) longLongValueForKeyPath:(NSString *)keyPath{
    return [self longLongValueForKeyPath:keyPath defaultValue:0];
}

-(float) floatValueForKeyPath:(NSString *) keyPath defaultValue:(float)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(floatValue)]){
        return [value floatValue];
    }
    return defalutValue;
}

-(float) floatValueForKeyPath:(NSString *) keyPath{
    return [self floatValueForKeyPath:keyPath defaultValue:0.0f];
}

-(double) doubleValueForKeyPath:(NSString *) keyPath defaultValue:(double)defalutValue{
    id value = [self objectValueForKeyPath:keyPath];
    if([value respondsToSelector:@selector(doubleValue)]){
        return [value doubleValue];
    }
    return defalutValue;
}

-(double) doubleValueForKeyPath:(NSString *) keyPath{
    return [self doubleValueForKeyPath:keyPath defaultValue:0.0];
}

-(id) objectValueForKeyPath:(NSString *) keyPath defaultValue:(id)defalutValue{
    
    if([self isKindOfClass:[NSNull class]]
       || [self isKindOfClass:[NSString class]]
       || [self isKindOfClass:[NSNumber class]]
       || keyPath == nil){
        return defalutValue;
    }
    
    @try {
        return [self valueForKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        
    }
    return defalutValue;
}

-(id) objectValueForKeyPath:(NSString *) keyPath{
    return [self objectValueForKeyPath:keyPath defaultValue:nil];
}

-(NSDictionary *) dictionaryValueForKeyPath:(NSString *)keyPath{
    id v = [self objectValueForKeyPath:keyPath];
    if([v isKindOfClass:[NSDictionary class]]){
        return v;
    }
    return nil;
}

-(NSArray *) arrayValueForKeyPath:(NSString *)keyPath{
    id v = [self objectValueForKeyPath:keyPath];
    if([v isKindOfClass:[NSArray class]]){
        return v;
    }
    return nil;
}

-(void) setObjectValue:(id) value forKey:(NSString *) key{
    
    @try {
        [self setValue:value forKey:key];
    }
    @catch (NSException *exception) {
    }
}

-(void) setObjectValue:(id) value forKeyPath:(NSString *) keyPath{
    
    @try {
        [self setValue:value forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
    }
}

-(NSArray *) arrayValue{
    if([self isKindOfClass:[NSArray class]]){
        return (NSArray *) self;
    }
    return nil;
}

-(NSDictionary *) dictionaryValue{
    if([self isKindOfClass:[NSDictionary class]]){
        return (NSDictionary *) self;
    }
    return nil;
}

-(id) objectValueAtIndex:(NSUInteger) index{
    if([self isKindOfClass:[NSArray class]] && index < [(NSArray *)self count]){
        return [(NSArray *) self objectAtIndex:index];
    }
    return nil;
}

@end
