//
//  VTElement.h
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VTDocument;
@protocol IVTViewEntity;

@interface VTElement : NSObject<NSCoding,NSCoding>

@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,readonly) NSDictionary * attributes;
@property(nonatomic,readonly) NSArray * childs;
@property(nonatomic,weak) VTElement * parentElement;
@property(nonatomic,weak) VTDocument * document;
@property(nonatomic,retain) NSString * elementId;
@property(nonatomic,weak) id<IVTViewEntity> viewEntity;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key;

-(NSString *) attributeValueForKey:(NSString *) key;

-(void) addChild:(VTElement *) element;

-(void) insertChild:(VTElement *) element atIndex:(NSUInteger) index;

-(void) removeFromParent;

-(BOOL) elementWillAppera:(VTElement *) element;

-(void) elementDidAppera:(VTElement *) element;

-(BOOL) elementWillDisappera:(VTElement *) element;

-(void) elementDidDisappera:(VTElement *) element;

-(id<IVTViewEntity>) elementViewEntity:(VTElement *) element;

-(void) setNeedsDisplay;

-(void) doAction;

-(id) initWithAttributes:(NSDictionary *) attributes;

@end
