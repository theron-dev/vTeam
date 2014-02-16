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

-(UIEdgeInsets) edgeInsetsValueForKey:(NSString *) key{
    CGFloat top = 0,left = 0,bottom = 0,right = 0;
    NSString * v = [self stringValueForKey:key];
    if(v){
        sscanf([v UTF8String], "%f %f %f %f",& top,& left,& bottom,& right);
    }
    return UIEdgeInsetsMake(top, left, bottom, right);
}

@end
