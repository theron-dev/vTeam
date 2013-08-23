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
@synthesize indexPath = _indexPath;

-(void) dealloc{
    [_styleSheet removeObserver:self forKeyPath:@"version"];
    [_bundle release];
    [_rootElement release];
    [_styleSheet release];
    [_elementsById release];
    [_indexPath release];
    [super dealloc];
}

-(void) applyStyleSheet:(VTDOMElement *) element{
    if(_styleSheet && element){
        NSString * styleName = [element attributeValueForKey:@"class"];
        if([styleName length]){
            styleName = [NSString stringWithFormat:@"%@ %@",element.name, styleName];
        }
        else{
            styleName = element.name;
        }
        [element setStyle:[_styleSheet selectorStyleName:styleName]];
        
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
        
        [_styleSheet removeObserver:self forKeyPath:@"version"];
        
        [styleSheet retain];
        [_styleSheet release];
        _styleSheet = styleSheet;
        
        [_styleSheet addObserver:self forKeyPath:@"version" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        [self applyStyleSheet:_rootElement];
        
    }
    
}

-(VTDOMElement *) elementById:(NSString *) eid{
    return [_elementsById objectForKey:eid];
}

-(NSArray *) elementsByClass:(Class) clazz inherit:(BOOL)inherit{
    NSMutableArray * elements = [NSMutableArray arrayWithCapacity:4];
    [_rootElement searchElementsByClass:clazz inherit:inherit toElements:elements];
    return elements;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object == _styleSheet){
        if([keyPath isEqualToString:@"version"]){
            [self applyStyleSheet:_rootElement];
            [_rootElement setNeedDisplay];
        }
    }
}

@end
