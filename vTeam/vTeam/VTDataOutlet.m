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
        if([key hasPrefix:@"@last"]){
            return [(NSArray *)self lastObject];
        }
        else if([key hasPrefix:@"@"]){
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
    return [v dataForKeyPath:[keyPath substringFromIndex:r.location + r.length]];
}

@end

@implementation NSString (VTDataOutlet)

-(NSString *) stringByDataOutlet:(id) data{
    NSMutableString * ms = [NSMutableString stringWithCapacity:30];
    NSMutableString * keyPath = [NSMutableString stringWithCapacity:30];
    
    unichar uc;
    
    int length = [self length];
    int s = 0;
    
    for(int i=0;i<length;i++){
        
        uc = [self characterAtIndex:i];
        
        switch (s) {
            case 0:
            {
                if(uc == '{'){
                    NSRange r = {0,[keyPath length]};
                    [keyPath deleteCharactersInRange:r];
                    s =1;
                }
                else{
                    [ms appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            case 1:
            {
                if(uc == '}'){
                    id v = [data dataForKeyPath:keyPath];
                    if(v){
                        [ms appendFormat:@"%@",v];
                    }
                    s = 0;
                }
                else{
                    [keyPath appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return ms;
}

@end

@implementation VTDataOutlet

@synthesize view = _view;
@synthesize keyPath = _keyPath;
@synthesize stringKeyPath = _stringKeyPath;
@synthesize stringFormat = _stringFormat;
@synthesize booleanKeyPath = _booleanKeyPath;
@synthesize enabledKeyPath = _enabledKeyPath;
@synthesize disabledKeyPath = _disabledKeyPath;
@synthesize value = _value;
@synthesize status = _status;
@synthesize valueKeyPath = _valueKeyPath;

-(void) dealloc{
    [_status release];
    [_view release];
    [_keyPath release];
    [_stringKeyPath release];
    [_stringFormat release];
    [_booleanKeyPath release];
    [_enabledKeyPath release];
    [_disabledKeyPath release];
    [_valueKeyPath release];
    [_value release];
    [super dealloc];
}

-(BOOL) booleanValue:(id) value{
    if(value){
        if([value isKindOfClass:[NSString class]]){
            if([value isEqualToString:@"false"] || [value isEqualToString:@""] || [value isEqualToString:@"0"]){
                return NO;
            }
            else{
                return YES;
            }
        }
        else if([value respondsToSelector:@selector(boolValue)] && ![value boolValue]){
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}

-(void) applyDataOutlet:(id)data{
    
    if(_enabledKeyPath){
        if(![self booleanValue:[data dataForKeyPath:_enabledKeyPath]]){
            return;
        }
    }
    
    if(_disabledKeyPath){
        if([self booleanValue:[data dataForKeyPath:_disabledKeyPath]]){
            return;
        }
    }
    
    id value = _value;
    if(_stringKeyPath){
        value = [data dataForKeyPath:_stringKeyPath];
        if(value && ![value isKindOfClass:[NSString class]]){
            value = [NSString stringWithFormat:@"%@",value];
        }
    }
    else if(_booleanKeyPath){
        value = [data dataForKeyPath:_booleanKeyPath];
        value = [NSNumber numberWithBool:[self booleanValue:value]];
    }
    else if(_stringFormat){
        value = [_stringFormat stringByDataOutlet:data];
    }
    else if(_valueKeyPath){
        value = [data dataForKeyPath:_valueKeyPath];
    }
    [_view setValue:value forKeyPath:self.keyPath];
}

@end
