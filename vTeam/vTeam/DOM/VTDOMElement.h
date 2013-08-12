//
//  VTDOMElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDOMStyle.h>

@interface VTDOMElement : NSObject

@property(nonatomic,retain) NSString * ns;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,readonly) VTDOMStyle * style;
@property(nonatomic,readonly) NSDictionary * attributes;
@property(nonatomic,assign) VTDOMElement * parentElement;
@property(nonatomic,readonly) NSArray * childs;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key;

-(void) removeAttributeForKey:(NSString *) key;

-(void) removeAllAttributes;

-(NSString *) attributeValueForKey:(NSString *) key;

-(void) addElement:(VTDOMElement *) element;

-(void) insertElement:(VTDOMElement *) element atIndex:(NSUInteger) index;

-(void) removeFromParentElement;

@end
