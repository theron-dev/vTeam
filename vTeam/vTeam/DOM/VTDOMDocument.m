//
//  VTDOMDocument.m
//  vTeam
//
//  Created by zhang hailong on 13-8-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMDocument.h"

@interface VTDOMDocument(){
    NSMutableDictionary * _elementsById;
}

-(void) scanfElements:(VTDOMElement *) element;

@end

@implementation VTDOMDocument

@synthesize bundle = _bundle;
@synthesize rootElement = _rootElement;
@synthesize styleSheet = _styleSheet;

-(void) dealloc{
    [_bundle release];
    [_rootElement release];
    [_styleSheet release];
    [_elementsById release];
    [super dealloc];
}

-(void) applyStyleSheet:(VTDOMElement *) element{
    if(_styleSheet && element){
        NSString * styleName = [element attributeValueForKey:@"class"];
        if([styleName length]){
            [element setStyle:[_styleSheet selectorStyleName:styleName]];
        }
        for(VTDOMElement * child in [element childs]){
            [self applyStyleSheet:child];
        }
    }
}

-(void) scanfElements:(VTDOMElement *) element{
    if(element){
        NSString * eid = [element attributeValueForKey:@"id"];
        if(eid){
            if([_elementsById valueForKey:eid] == nil){
                [_elementsById setObject:element forKey:eid];
            }
        }
        for(VTDOMElement * child in [element childs]){
            [self scanfElements:child];
        }
    }
}

-(void) setRootElement:(VTDOMElement *)rootElement{
    if(_rootElement != rootElement){
        [rootElement retain];
        [_rootElement release];
        _rootElement = rootElement;
        [_rootElement setParentElement:nil];
        [_rootElement setDocument:self];
        [self applyStyleSheet:_rootElement];
        if(_elementsById == nil){
            _elementsById = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        else{
            [_elementsById removeAllObjects];
        }
        [self scanfElements:_rootElement];
    }
}

-(void) setStyleSheet:(VTDOMStyleSheet *)styleSheet{
    
    if(_styleSheet != styleSheet){
        
        [styleSheet retain];
        [_styleSheet release];
        _styleSheet = styleSheet;
        
        [self applyStyleSheet:_rootElement];
        
    }
    
}

-(VTDOMElement *) elementById:(NSString *) eid{
    return [_elementsById objectForKey:eid];
}

@end
