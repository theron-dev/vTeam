//
//  VTDOMStatusElement.m
//  vTeam
//
//  Created by zhang hailong on 14-2-19.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMStatusElement.h"

#import "VTDOMElement+Render.h"

#import "VTDOMElement+Control.h"

#import "VTDOMElement+Style.h"

#import "VTDOMViewElement.h"

#import "UIView+VTDOMElement.h"

@interface VTDOMStatusElement(){
    BOOL _insetTouch;
}

@end

@implementation VTDOMStatusElement

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    [super setAttributeValue:value forKey:key];
    if([key isEqualToString:@"status"]){
        [self refreshStatus];
    }
}

-(void) refreshStatusForElement:(VTDOMElement *) element forStatus:(NSString *) status{
    
    NSString * s = [element attributeValueForKey:@"status"];
    
    if(status == nil || s == nil || s == status || [status isEqualToString:s]){
        [element setAttributeValue:@"false" forKey:@"hidden"];
    }
    else {
        
        NSSet * ss = [NSSet setWithArray:[s componentsSeparatedByString:@","]];
        
        if([ss containsObject:status]){
            [element setAttributeValue:@"false" forKey:@"hidden"];
        }
        else{
            [element setAttributeValue:@"true" forKey:@"hidden"];
        }
    }

    [element setAttributeValue:status forKey:@"tostatus"];
    
    if([element isKindOfClass:[VTDOMViewElement class]] && [(VTDOMViewElement *)element isViewLoaded]){
        [[(VTDOMViewElement *)element view] setElement:element];
    }
    
    [element setNeedDisplay];
}

-(void) refreshStatus{
    
    NSString * status = [self attributeValueForKey:@"status"];
    
    for(VTDOMElement * el in [self childs]){
        [self refreshStatusForElement:el forStatus:status];
    }
    
}

-(void) elementDidAppera:(VTDOMElement *)element{
    [super elementDidAppera:element];
    [self refreshStatusForElement:element forStatus:[self attributeValueForKey:@"status"]];
}


-(NSString *) status{
    return [self attributeValueForKey:@"status"];
}

-(void) setStatus:(NSString *)status{
    [self setAttributeValue:status forKey:@"status"];
}

-(UIColor *) backgroundColor{
    
    NSString * key = [self status];
    
    if([key length]){
        UIColor * color = [self colorValueForKey:[@"background-color-" stringByAppendingString:key]];
        if(color == nil){
            [self colorValueForKey:@"background-color"];
        }
        return color;
    }
    
    return [self colorValueForKey:@"background-color"];
   
}


@end
