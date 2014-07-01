//
//  VTElement.m
//  vElement
//
//  Created by zhang hailong on 14-6-30.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTElement.h"

@interface VTElement(){
    NSMutableDictionary * _attributes;
    NSMutableArray * _childs;
}

@end

@implementation VTElement

@synthesize ns = _ns;
@synthesize name = _name;
@synthesize text = _text;
@synthesize attributes = _attributes;
@synthesize parentElement = _parentElement;
@synthesize childs = _childs;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_ns forKey:@"ns"];
    [aCoder encodeObject:_text forKey:@"text"];
    [aCoder encodeObject:_attributes forKey:@"attributes"];
    [aCoder encodeObject:_childs forKey:@"childs"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])){
        
        _name = [aDecoder decodeObjectForKey:@"name"];
        _ns = [aDecoder decodeObjectForKey:@"ns"];
        _text = [aDecoder decodeObjectForKey:@"text"];
        
        _attributes = [aDecoder decodeObjectForKey:@"attributes"];
        _childs = [aDecoder decodeObjectForKey:@"childs"];
        
        for(VTElement * element in _childs){
            [element setParentElement:self];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    
    VTElement * element = [[[self class] alloc] init];
    
    element.name = self.name;
    element.ns = self.ns;
    element.text = self.text;
    element->_attributes = _attributes ? [[NSMutableDictionary alloc] initWithDictionary:_attributes] : nil;
    
    for(VTElement * el in _childs){
        
        [element addElement:[el copyWithZone:zone]];
        
    }
    
    return element;
}

-(void) dealloc{
    
    for(VTElement * element in _childs){
        [element setParentElement:nil];
    }
    
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

-(void) addElement:(VTElement *) element{
    
    [element setParentElement:self];
    if(_childs == nil){
        _childs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_childs addObject:element];

}

-(void) insertElement:(VTElement *) element atIndex:(NSUInteger) index{
    
    [element setParentElement:self];
    if(_childs == nil){
        _childs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    if(index < [_childs count]){
        [_childs insertObject:element atIndex:index];
    }
    else{
        [_childs addObject:element];
    }
    
}


@end
