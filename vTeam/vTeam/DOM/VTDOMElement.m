//
//  VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement.h"

@interface VTDOMElement(){
    NSMutableDictionary * _attributes;
    NSMutableArray * _childs;
}

@end

@implementation VTDOMElement

@synthesize ns = _ns;
@synthesize name = _name;
@synthesize attributes = _attributes;
@synthesize style = _style;
@synthesize parentElement = _parentElement;
@synthesize childs = _childs;

-(void) dealloc{
    for(VTDOMElement * element in _childs){
        [element setParentElement:nil];
    }
    [_ns release];
    [_name release];
    [_attributes release];
    [_style release];
    [super dealloc];
}

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    if(_attributes == nil){
        _attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    [_attributes setValue:value forKey:key];
}

-(NSString *) attributeValueForKey:(NSString *)key{
    return [_attributes valueForKey:key];
}

-(void) removeAttributeForKey:(NSString *) key{
    [_attributes removeObjectForKey:key];
}

-(void) removeAllAttributes{
    [_attributes removeAllObjects];
}

-(void) addElement:(VTDOMElement *) element{
    
}

-(void) insertElement:(VTDOMElement *) element atIndex:(NSUInteger) index{
    
}

-(void) removeFromParentElement{
    
}

@end
