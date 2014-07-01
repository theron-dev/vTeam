//
//  VTElement.m
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTElement.h"

#import "IVTViewEntity.h"

@interface VTElement(){
    NSMutableDictionary * _attributes;
    NSMutableArray * _childs;
}

@end

@implementation VTElement

@synthesize name = _name;
@synthesize text = _text;
@synthesize attributes = _attributes;
@synthesize childs = _childs;
@synthesize parentElement = _parentElement;
@synthesize document = _document;
@synthesize viewEntity = _viewEntity;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key{
    if(value){
        if(_attributes == nil){
            _attributes = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        [_attributes setValue:value forKey:key];
    }
    else {
        [_attributes removeObjectForKey:key];
    }
}

-(NSString *) attributeValueForKey:(NSString *) key{
    return [_attributes valueForKey:key];
}

-(BOOL) elementWillAppera:(VTElement *) element{
    return YES;
}

-(void) elementDidAppera:(VTElement *) element{
    
}

-(BOOL) elementWillDisappera:(VTElement *) element{
    return YES;
}

-(void) elementDidDisappera:(VTElement *) element{
    
}

-(void) addChild:(VTElement *) element{
    
    if([self elementWillAppera:element]){
        
        [element removeFromParent];
        
        [element setParentElement:self];
        [element setDocument:_document];
        
        if(_childs == nil){
            _childs = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        [_childs addObject:element];
        
        [self elementDidAppera:element];
    }
    
}

-(void) insertChild:(VTElement *) element atIndex:(NSUInteger) index{
    
    if([self elementWillAppera:element]){
        
        [element removeFromParent];
        
        [element setParentElement:self];
        [element setDocument:_document];
        
        if(_childs == nil){
            _childs = [[NSMutableArray alloc] initWithCapacity:4];
        }
        
        [_childs insertObject:element atIndex:index];
        
        [self elementDidAppera:element];
    }
    
}

-(void) removeFromParent{
    
    if([_parentElement elementWillAppera:self]){
       
        __block VTElement * parent = _parentElement;
        
        __block VTElement * element = self;

        [parent->_childs removeObject:element];
       
        element->_parentElement = nil;
        element->_document = nil;
        
        [parent elementWillDisappera:element];
        
    }
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_name];
    [aCoder encodeObject:_text];
    [aCoder encodeObject:_attributes];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:[_childs count]]];
    
    for (VTElement * child in _childs) {
        
        [aCoder encodeObject:child];
        
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if((self = [super init])){
        
        _name = [aDecoder decodeObject];
        _text = [aDecoder decodeObject];
        _attributes = [aDecoder decodeObject];
        
        NSUInteger childCount = [[aDecoder decodeObject] unsignedIntegerValue];
        
        for (int i=0;i<childCount; i++) {
            
            VTElement * child = [aDecoder decodeObject];
        
            [self addChild:child];
            
        }
    }
    
    return self;
}

-(NSString *) elementId{
    return [self attributeValueForKey:@"id"];
}

-(void) setElementId:(NSString *)elementId{
    [self setAttributeValue:elementId forKey:@"id"];
}

-(id) initWithAttributes:(NSDictionary *) attributes{
    if((self = [super init])){
        _attributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    }
    return self;
}

-(id<IVTViewEntity>) elementViewEntity:(VTElement *) element{
    if(_viewEntity == nil && _parentElement != nil){
        return [_parentElement elementViewEntity:element];
    }
    return _viewEntity;
}

-(id<IVTViewEntity>) viewEntity{
    if(_viewEntity == nil && _parentElement != nil){
        return [_parentElement elementViewEntity:self];
    }
    return _viewEntity;
}

-(void) setNeedsDisplay{
    id<IVTViewEntity> viewEntity = [self viewEntity];
    [viewEntity elementDoNeedsDisplay:self];
}

-(void) doAction{
    id<IVTViewEntity> viewEntity = [self viewEntity];
    [viewEntity elementDoAction:viewEntity element:self];
}

@end
