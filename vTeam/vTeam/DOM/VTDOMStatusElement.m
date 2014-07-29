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

@interface VTDOMElement(VTDOMStatusElement)


@property(nonatomic,readonly) NSSet * statusSet;


@end

@implementation VTDOMElement(VTDOMStatusElement)

-(NSSet *) statusSet{
    
    NSSet * statusSet = [self valueForKey:@"statusSet"];
    
    if(statusSet == nil){
        
        NSArray * ss = [[self attributeValueForKey:@"status"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|,; "]];
        
        statusSet = ss ? [NSSet setWithArray:ss] : [NSSet set];
    
    }
    
    return statusSet;
}

@end

@interface VTDOMStatusElement(){
    BOOL _insetTouch;
}

@end

@implementation VTDOMStatusElement

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    [super setAttributeValue:value forKey:key];
    if([key isEqualToString:@"status"]){
        [self setValue:nil forKey:@"statusSet"];
        [self refreshStatus];
    }
}

-(void) refreshStatusForElement:(VTDOMElement *) element{
    
    NSSet * status = [self statusSet];
    NSSet * s = [element statusSet];

    if([s count] == 0 || [s intersectsSet:status]){
        [element setAttributeValue:@"false" forKey:@"hidden"];
    }
    else {
        [element setAttributeValue:@"true" forKey:@"hidden"];
    }

    [element setValue:status forKey:@"tostatus"];
    
    if([element isKindOfClass:[VTDOMViewElement class]] && [(VTDOMViewElement *)element isViewLoaded]){
        [[(VTDOMViewElement *)element view] setElement:element];
    }
    
    [element setNeedDisplay];
}

-(void) refreshStatus{
    

    for(VTDOMElement * el in [self childs]){
        [self refreshStatusForElement:el];
    }
    
}

-(void) elementDidAppera:(VTDOMElement *)element{
    [super elementDidAppera:element];
    [self refreshStatusForElement:element];
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

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(highlighted){
        NSMutableSet * statusSet = [NSMutableSet setWithSet:[self statusSet]];
        [statusSet addObject:@"highlighted"];
        [self setValue:statusSet forKey:@"statusSet"];
        [self refreshStatus];
    }
    else {
        NSMutableSet * statusSet = [NSMutableSet setWithSet:[self statusSet]];
        [statusSet removeObject:@"highlighted"];
        [self setValue:statusSet forKey:@"statusSet"];
        [self refreshStatus];
    }
}


@end
