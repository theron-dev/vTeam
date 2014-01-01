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
@property(nonatomic,assign) id delegate;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key;

-(void) removeAttributeForKey:(NSString *) key;

-(void) removeAllAttributes;

-(NSString *) attributeValueForKey:(NSString *) key;

-(void) addElement:(VTDOMElement *) element;

-(void) insertElement:(VTDOMElement *) element atIndex:(NSUInteger) index;

-(void) removeFromParentElement;

-(id) valueForKey:(NSString *)key;

-(void) setValue:(id)value forKey:(NSString *)key;

-(void) setNeedDisplay;

-(void) searchElementsByClass:(Class) clazz inherit:(BOOL)inherit toElements:(NSMutableArray *) elements;

-(void) bindDelegate:(id) delegate;

-(void) unbindDelegate:(id) delegate;

@end

@protocol VTDOMElementDelegate

@optional

-(void) vtDOMElementDoAction:(VTDOMElement *) element;

-(void) vtDOMElementDoNeedDisplay:(VTDOMElement *) element;

-(void) vtDOMElement:(VTDOMElement *) element addLayer:(CALayer *) layer frame:(CGRect) frame;

-(void) vtDOMElement:(VTDOMElement *) element addView:(UIView *) view frame:(CGRect) frame;

-(UIView *) vtDOMElementView:(VTDOMElement *) element viewClass:(Class)viewClass;

@end