//
//  VTElementXMLParser.m
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTElementXMLParser.h"

@interface VTElementXMLParser(){
    NSMutableDictionary * _elementClasss;
    VTElement * _element;
    NSMutableString * _text;
}

@end

@implementation VTElementXMLParser

-(void) loadLibrarys{
    
}

-(void) setElementClass:(Class) clazz forName:(NSString *) name{
    
    if(_elementClasss == nil){
        _elementClasss = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    [_elementClasss setValue:[NSValue valueWithPointer:(const void *) clazz] forKey:name];
}

-(VTElement *) parse:(NSXMLParser *) parser{
    
    _element = nil;
    
    [parser setDelegate:self];
    
    [parser parse];
    
    [parser setDelegate:nil];
    
    return _element;
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    Class clazz = [[_elementClasss valueForKey:qName] pointerValue];
    
    if(clazz == nil){
        clazz = [VTElement class];
    }
    
    VTElement * element = [[VTElement alloc] initWithAttributes:attributeDict];
    
    if(_element){
        [_element addChild:element];
        _element = element;
    }
    else {
        _element = element;
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if(_text){
        
        [_element setText:_text];
        
        _text = nil;
    }
    
    _element = [_element parentElement];
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(_text == nil){
        _text = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [_text appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    if(_text == nil){
        _text = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }
    else {
        [_text appendString:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
    }
}

@end
