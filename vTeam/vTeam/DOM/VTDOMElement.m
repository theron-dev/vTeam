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
    NSMutableDictionary * _values;
}

@end

@implementation VTDOMElement

@synthesize ns = _ns;
@synthesize name = _name;
@synthesize text = _text;
@synthesize attributes = _attributes;
@synthesize style = _style;
@synthesize parentElement = _parentElement;
@synthesize childs = _childs;
@synthesize document = _document;
@synthesize delegate = _delegate;

-(void) dealloc{
    for(VTDOMElement * element in _childs){
        [element setParentElement:nil];
    }
    [_ns release];
    [_name release];
    [_attributes release];
    [_style release];
    [_text release];
    [_values release];
    [_childs release];
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
    [element setParentElement:self];
    [element setDocument:_document];
    if(_childs == nil){
        _childs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_childs addObject:element];
}

-(void) insertElement:(VTDOMElement *) element atIndex:(NSUInteger) index{
    [element setParentElement:self];
    [element setDocument:_document];
    if(_childs == nil){
        _childs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_childs insertObject:element atIndex:index];
}

-(void) removeFromParentElement{
    if(_parentElement){
        VTDOMElement * parent = _parentElement;
        [self setParentElement:nil];
        [self setDocument:nil];
        [parent->_childs removeObject:self];
    }
}

-(NSString *) eid{
    return [_attributes valueForKey:@"id"];
}

-(void) setEid:(NSString *)eid{
    [self setAttributeValue:eid forKey:@"id"];
}

-(void) setDocument:(VTDOMDocument *)document{
    _document = document;
    for(VTDOMElement * element in _childs){
        [element setDocument:document];
    }
}

-(id) valueForKey:(NSString *)key{
    return [_values valueForKey:key];
}

-(void) setValue:(id)value forKey:(NSString *)key{
    if(_values == nil){
        _values = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    [_values setValue:value forKey:key];
}

-(void) setNeedDisplay{
    if([_delegate respondsToSelector:@selector(vtDOMElementDoNeedDisplay:)]){
        [_delegate vtDOMElementDoNeedDisplay:self];
    }
}

-(void) searchElementsByClass:(Class) clazz inherit:(BOOL)inherit toElements:(NSMutableArray *) elements{
    if(inherit ? [self isKindOfClass:clazz] : [self class] == clazz){
        [elements addObject:self];
    }
    for(VTDOMElement * el in [self childs]){
        [el searchElementsByClass:clazz inherit:inherit toElements:elements];
    }
}

-(void) setStyle:(VTDOMStyle *)style{
    if(_style != style){
        [style retain];
        [_style release];
        _style  = style;
        [self setNeedDisplay];
    }
}

-(void) bindDelegate:(id) delegate{
    [self setDelegate:delegate];
    for (VTDOMElement * element in [self childs]) {
        [element bindDelegate:delegate];
    }
}

-(void) unbindDelegate:(id) delegate{
    if(self.delegate == delegate){
        [self setDelegate:nil];
        for (VTDOMElement * element in [self childs]) {
            [element unbindDelegate:delegate];
        }
    }
}

@end
