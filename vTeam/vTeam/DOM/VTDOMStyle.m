//
//  VTDOMStyle.m
//  vTeam
//
//  Created by zhang hailong on 13-8-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMStyle.h"

@interface VTDOMStyle(){
    NSMutableDictionary * _values;
}

@end

@implementation VTDOMStyle

-(void) dealloc{
    [_values release];
    [super dealloc];
}

-(NSArray *) allKeys{
    return [_values allKeys];
}

-(void) setStringValue:(NSString *) value forKey:(NSString *) key{
    if(_values == nil){
        _values = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    [_values setValue:value forKey:key];
}

-(NSString *) stringValueForKey:(NSString *) key{
    return [_values valueForKey:key];
}

-(float) floatValueForKey:(NSString *) key{
    return [VTDOMStyle floatValue:[self stringValueForKey:key]];
}

-(BOOL) booleanValueForKey:(NSString *) key{
    return [VTDOMStyle booleanValue:[self stringValueForKey:key]];
}

-(UIImage *) imageValueForKey:(NSString *) key bundle:(NSBundle *) bundle{
    return [VTDOMStyle imageValue:[self stringValueForKey:key] bundle:bundle];
}

-(UIColor *) colorValueForKey:(NSString *) key{
    return [VTDOMStyle colorValue:[self stringValueForKey:key]];
}

-(UIFont *) fontValueForKey:(NSString *) key{
    return [VTDOMStyle fontValue:[self stringValueForKey:key]];
}


+(float) floatValue:(NSString *) value{
    return [value floatValue];
}

+(BOOL) booleanValue:(NSString *) value{
    return value && ([value boolValue] || [value isEqualToString:@"true"]);
}

+(UIImage *) imageValue:(NSString *) value bundle:(NSBundle *) bundle{
    
    if(value){
        
        if(![value hasPrefix:@"http://"]){
            
            NSArray * vs = [value componentsSeparatedByString:@" "];
            NSString * path = nil;
            
            if([vs count] >0){
                path = [vs objectAtIndex:0];
            }
            
            UIImage * image = [UIImage imageNamed: bundle == nil ? path : [[bundle bundlePath] stringByAppendingPathComponent:path]];
            
            if(image){
                NSInteger left = 0;
                NSInteger top = 0;
                if([vs count] > 1){
                    left = [[vs objectAtIndex:1] intValue];
                }
                if([vs count] >2){
                    top = [[vs objectAtIndex:2] intValue];
                }
                if(left || top){
                    image = [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
                }
            }
            
            return image;
        }
        
    }
    
    return nil;
}

+(UIColor *) colorValue:(NSString *) value{
    if([value isEqualToString:@"clear"]){
        return [UIColor clearColor];
    }
    if(value){
        int r=0,g=0,b=0;
        float a = 1.0;
        sscanf([value UTF8String], "#%02x%02x%02x %f",&r,&g,&b,&a);
        return [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a];
    }
    return nil;
}

+(UIFont *) fontValue:(NSString *) value{
    if(value){
        
        NSArray * vs = [value componentsSeparatedByString:@" "];
        
        CGFloat fontSize = 14;
        
        if([vs count] >0){
            fontSize = [[vs objectAtIndex:0] floatValue];
        }
        
        if([vs count] > 1){
            NSString * fontName = [vs objectAtIndex:1];
            if([fontName isEqualToString:@"bold"]){
                return [UIFont boldSystemFontOfSize:fontSize];
            }
            else if([fontName isEqualToString:@"italic"]){
                return [UIFont italicSystemFontOfSize:fontSize];
            }
            else {
                UIFont * font = [UIFont fontWithName:fontName size:fontSize];
                if(font == nil){
                    return [UIFont systemFontOfSize:fontSize];
                }
                return font;
            }
        }
        
        return [UIFont systemFontOfSize:fontSize];
    }
    return nil;
}

@end
