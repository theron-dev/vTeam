//
//  VTDataOutlet.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataOutlet.h>

@implementation NSObject(VTDataOutlet)

-(id) dataForKey:(NSString *) key{
    if([self isKindOfClass:[NSString class]]){
        return nil;
    }
    if([self isKindOfClass:[NSNumber class]]){
        return nil;
    }
    if([self isKindOfClass:[NSNull class]]){
        return nil;
    }
    if([self isKindOfClass:[NSArray class]]){
        if([key hasPrefix:@"@"]){
            NSInteger index = [[key substringFromIndex:1] intValue];
            if(index >=0 && index < [(NSArray *)self count]){
                return [(NSArray *)self objectAtIndex:index];
            }
            return nil;
        }
    }
    return [self valueForKey:key];
}

-(id) dataForKeyPath:(NSString *) keyPath{
    NSRange r = [keyPath rangeOfString:@"."];
    if(r.location == NSNotFound){
        return [self dataForKey:keyPath];
    }
    id v = [self dataForKey:[keyPath substringToIndex:r.location]];
    if([keyPath length] > r.location + r.length){
        return [v dataForKeyPath:[keyPath substringFromIndex:r.location + r.length]];
    }
    return v;
}

@end

@implementation VTDataOutlet

@synthesize view = _view;
@synthesize keyPath = _keyPath;
@synthesize stringKeyPath = _stringKeyPath;
@synthesize stringFormat = _stringFormat;
@synthesize booleanKeyPath = _booleanKeyPath;

-(void) dealloc{
    [_view release];
    [_keyPath release];
    [_stringKeyPath release];
    [_stringFormat release];
    [_booleanKeyPath release];
    [super dealloc];
}

-(void) applyDataOutlet:(id)data{
    id value = nil;
    if(_stringKeyPath){
        value = [data dataForKeyPath:_stringKeyPath];
        if(value && ![value isKindOfClass:[NSString class]]){
            value = [NSString stringWithFormat:@"%@",value];
        }
    }
    else if(_booleanKeyPath){
        value = [data dataForKeyPath:_booleanKeyPath];
        if(value){
            if([value isKindOfClass:[NSString class]]){
                if([value isEqualToString:@"false"] || [value isEqualToString:@""] || [value isEqualToString:@"0"]){
                    value = [NSNumber numberWithBool:NO];
                }
                else{
                    value = [NSNumber numberWithBool:YES];
                }
            }
            else if(![value boolValue]){
                value = [NSNumber numberWithBool:NO];
            }
            else{
                value = [NSNumber numberWithBool:YES];
            }
        }
        else{
            value = [NSNumber numberWithBool:NO];
        }
    }
    [_view setValue:value forKeyPath:self.keyPath];
}

@end
