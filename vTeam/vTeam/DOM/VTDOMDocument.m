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
@synthesize documentURL = _documentURL;

-(void) dealloc{
    [_rootElement setDocument:nil];
    [_styleSheet removeObserver:self forKeyPath:@"version"];
    [_bundle release];
    [_rootElement release];
    [_styleSheet release];
    [_elementsById release];
    [_indexPath release];
    [_documentURL release];
    [super dealloc];
}

-(NSString *) forStyleNameInElement:(VTDOMElement *) element{
    VTDOMElement * el  = [element parentElement];
    
    while(el){
        
        NSString * v = [el attributeValueForKey:@"class"];
        
        if([v length]){
            return [[v componentsSeparatedByString:@" "] lastObject];
        }
        
        el = [el parentElement];
    }
    
    return nil;
}

-(void) applyStyleSheet:(VTDOMElement *) element forStyleName:(NSString *) forStyleName{
    if(_styleSheet && element){
        
        NSString * styleName = element.name;
        
        if(styleName == nil){
            styleName = @"";
        }
        
        if([forStyleName length]){
            styleName = [styleName stringByAppendingFormat:@" %@.%@",forStyleName,element.name];
        }
        
        NSString * v = [element attributeValueForKey:@"class"];
        
        if([v length]){
            styleName = [styleName stringByAppendingFormat:@" %@",v];
        }
       
        [element setStyle:[_styleSheet selectorStyleName:styleName]];
        
        for(VTDOMElement * child in [element childs]){
            [self applyStyleSheet:child forStyleName: [v length] ? [[v componentsSeparatedByString:@" "] lastObject] : forStyleName];
        }
    }
}

-(void) applyStyleSheet:(VTDOMElement *) element{
    if(_styleSheet && element){
        [self applyStyleSheet:element forStyleName:[self forStyleNameInElement:element]];
    }
}

-(void) applyStyleSheet{
    [self applyStyleSheet:self.rootElement];
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

-(void) elementDidAppera:(VTDOMElement *) element{
    
    NSString * eid = [element attributeValueForKey:@"id"];
    
    if(eid){
        if([_elementsById valueForKey:eid] == nil){
            if(_elementsById == nil){
                _elementsById = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            [_elementsById setObject:element forKey:eid];
        }
    }
}

-(void) elementWillDisappera:(VTDOMElement *) element{
    
    NSString * eid = [element attributeValueForKey:@"id"];
    
    if(eid){
        if([_elementsById valueForKey:eid] == element){
            [_elementsById removeObjectForKey:eid];
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
