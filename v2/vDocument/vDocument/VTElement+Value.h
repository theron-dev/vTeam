//
//  VTElement+Value.h
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vDocument/VTElement.h>

@interface VTElement (Value)

-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *) defaultValue;

-(NSString *) stringValueForKey:(NSString *) key;

-(CGFloat) floatValueForKey:(NSString *) key defaultValue:(CGFloat) defaultValue;

-(CGFloat) floatValueForKey:(NSString *) key;

-(CGFloat) floatValueForKey:(NSString *)key of:(CGFloat) of defaultValue:(CGFloat)defaultValue;

-(CGFloat) floatValueForKey:(NSString *)key of:(CGFloat) of;

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL) defaultValue;

@end
