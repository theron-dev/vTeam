//
//  VTCanvasElement.m
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTCanvasElement.h"

#import "VTElement+Value.h"

@implementation VTCanvasElement

-(BOOL) isHidden{
    return [self booleanValueForKey:@"hidden" defaultValue:NO] || ! [self booleanValueForKey:@"visable" defaultValue:YES];
}

-(CGFloat) cornerRadius{
    return [self floatValueForKey:@"corner-radius"];
}

-(void) setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    [super setAttributeValue:value forKey:key];
    
    if([key isEqualToString:@"hidden"] || [key isEqualToString:@"visabled"] || [key isEqualToString:@"corner-radius"]){
        [self setNeedsDisplay];
    }
}

-(void) drawInContext:(CGContextRef) context{
    
    [self onDrawBackgroundInContext:context];
    
    [self onDrawBorderInContext:context];
    
    [self onDrawBorderInContext:context];
}

-(void) onDrawBackgroundInContext:(CGContextRef) context{
    
}

-(void) onDrawInContext:(CGContextRef) context{
    
}

-(void) onDrawBorderInContext:(CGContextRef) context{
    
}

@end
