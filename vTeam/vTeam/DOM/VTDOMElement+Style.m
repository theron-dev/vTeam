//
//  VTDOMElement+Style.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Style.h"

@implementation VTDOMElement (Style)

-(NSString *) stringValueForKey:(NSString *) key{
    NSString * v = [self attributeValueForKey:key];
    
    if(v == nil){
        
        NSString * style = [self attributeValueForKey:@"style"];
        
        if([style length]){
            
            NSMutableDictionary * styleMap = [self valueForKey:@"styleMap"];
            
            if(styleMap == nil){
            
                styleMap = [NSMutableDictionary dictionaryWithCapacity:4];
                
                NSArray * items = [style componentsSeparatedByString:@";"];
            
                for (NSString * item in items) {
                    
                    NSArray * ss = [item componentsSeparatedByString:@":"];
                    
                    if([ss count] > 1){
                        
                        NSString * key = [[ss objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
                        NSString * value = [[ss objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
                        [styleMap setValue:value forKey:key];
                        
                    }
                    
                }
                
                [self setValue:styleMap forKey:@"styleMap"];
                
            }
            
            v = [styleMap valueForKey:key];
            
        }
    }
    
    if(v == nil){
        v = [self.style stringValueForKey:key];
    }
    return v;
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

-(UIEdgeInsets) edgeInsetsValueForKey:(NSString *) key{
    double top = 0,left = 0,bottom = 0,right = 0;
    NSString * v = [self stringValueForKey:key];
    if(v){
        sscanf([v UTF8String], "%lf %lf %lf %lf",& top,& left,& bottom,& right);
    }
    return UIEdgeInsetsMake(top, left, bottom, right);
}

-(float) floatValueForKey:(NSString *) key of:(CGFloat) baseValue defaultValue:(CGFloat) defaultValue{
    
    NSString * v = [self stringValueForKey:key];
    
    if(v == nil){
        return defaultValue;
    }
    
    if([v isEqualToString:@"auto"]){
        return MAXFLOAT;
    }
    
    if([v hasSuffix:@"%"]){
        return [v floatValue] * baseValue / 100.0;
    }
    else {
        NSRange r = [v rangeOfString:@"%+"];
        
        if(r.location != NSNotFound){
            
            return [[v substringToIndex:r.location] floatValue] * baseValue / 100.0 + [[v substringFromIndex:r.location + r.length] floatValue];
            
        }
        else{
            
            r = [v rangeOfString:@"%-"];
            
            if(r.location != NSNotFound){
                return [[v substringToIndex:r.location] floatValue] * baseValue / 100.0 -[[v substringFromIndex:r.location + r.length] floatValue];
            }
            else{
                return [v floatValue];
            }
        }
    }

}

@end
