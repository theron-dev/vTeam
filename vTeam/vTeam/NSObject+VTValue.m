//
//  NSObject+VTValue.m
//  vTeam
//
//  Created by zhang hailong on 13-12-30.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSObject+VTValue.h"

@implementation NSObject (VTValue)

-(NSString *) stringValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value isKindOfClass:[NSString class]]){
        return value;
    }
    else if([value respondsToSelector:@selector(stringValue)]){
        return [value stringValue];
    }
    else if(value){
        return [NSString stringWithFormat:@"%@",value];
    }
    return nil;
}

-(BOOL) booleanValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(boolValue)]){
        return [value boolValue];
    }
    return 0;
}

-(int) intValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(intValue)]){
        return [value intValue];
    }
    return 0;
}

-(long) longValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(longValue)]){
        return [value longValue];
    }
    return 0;
}

-(long long) longLongValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(longLongValue)]){
        return [value longLongValue];
    }
    return 0;
}

-(float) floatValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(floatValue)]){
        return [value floatValue];
    }
    return 0;
}

-(double) doubleValueForKey:(NSString *) key{
    id value = [self objectValueForKey:key];
    if([value respondsToSelector:@selector(doubleValue)]){
        return [value doubleValue];
    }
    return 0;
}

-(id) objectValueForKey:(NSString *) key{
    
    if([self isKindOfClass:[NSNull class]]
       || [self isKindOfClass:[NSString class]]
       || [self isKindOfClass:[NSNumber class]]){
        return nil;
    }
    
    @try {
        return [self valueForKey:key];
    }
    @catch (NSException *exception) {
        
    }
    return nil;
}

@end
