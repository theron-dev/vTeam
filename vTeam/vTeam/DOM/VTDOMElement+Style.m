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

@end
