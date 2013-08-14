//
//  VTDOMElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDOMStyle.h>

@class VTDOMDocument;

@interface VTDOMElement : NSObject

@property(nonatomic,retain) NSString * ns;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,retain) VTDOMStyle * style;
@property(nonatomic,readonly) NSDictionary * attributes;
@property(nonatomic,assign) VTDOMElement * parentElement;
@property(nonatomic,readonly) NSArray * childs;
@property(nonatomic,retain) NSString * eid;
@property(nonatomic,assign) VTDOMDocument * document;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key;

-(void) removeAttributeForKey:(NSString *) key;

-(void) removeAllAttributes;

-(NSString *) attributeValueForKey:(NSString *) key;

-(void) addElement:(VTDOMElement *) element;

-(void) insertElement:(VTDOMElement *) element atIndex:(NSUInteger) index;

-(void) removeFromParentElement;

-(id) valueForKey:(NSString *)key;

-(void) setValue:(id)value forKey:(NSString *)key;

@end
