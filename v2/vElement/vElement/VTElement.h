//
//  VTElement.h
//  vElement
//
//  Created by zhang hailong on 14-6-30.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTElement : NSObject<NSCoding,NSCopying>

@property(nonatomic,retain) NSString * ns;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,readonly) NSDictionary * attributes;
@property(nonatomic,weak) VTElement * parentElement;
@property(nonatomic,readonly) NSArray * childs;

-(void) setAttributeValue:(NSString *) value forKey:(NSString *) key;

-(void) removeAttributeForKey:(NSString *) key;

-(void) removeAllAttributes;

-(NSString *) attributeValueForKey:(NSString *) key;

-(void) addElement:(VTElement *) element;

-(void) insertElement:(VTElement *) element atIndex:(NSUInteger) index;

-(void) removeFromParentElement;

@end
