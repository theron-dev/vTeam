//
//  NSObject+VTValue.h
//  vTeam
//
//  Created by zhang hailong on 13-12-30.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VTValue)

-(NSString *) stringValueForKey:(NSString *) key;

-(BOOL) booleanValueForKey:(NSString *) key;

-(int) intValueForKey:(NSString *) key;

-(long) longValueForKey:(NSString *) key;

-(long long) longLongValueForKey:(NSString *) key;

-(float) floatValueForKey:(NSString *) key;

-(double) doubleValueForKey:(NSString *) key;

-(id) objectValueForKey:(NSString *) key;

-(NSDictionary *) dictionaryValueForKey:(NSString *) key;

-(NSArray *) arrayValueForKey:(NSString *) key;




-(NSString *) stringValueForKeyPath:(NSString *) keyPath;

-(BOOL) booleanValueForKeyPath:(NSString *) keyPath;

-(int) intValueForKeyPath:(NSString *) keyPath;

-(long) longValueForKeyPath:(NSString *) keyPath;

-(long long) longLongValueForKeyPath:(NSString *) keyPath;

-(float) floatValueForKeyPath:(NSString *) keyPath;

-(double) doubleValueForKeyPath:(NSString *) keyPath;

-(id) objectValueForKeyPath:(NSString *) key;

-(NSDictionary *) dictionaryValueForKeyPath:(NSString *) key;

-(NSArray *) arrayValueForKeyPath:(NSString *) key;


-(NSString *) stringValueForKey:(NSString *) key defaultValue:(NSString *) defalutValue;

-(BOOL) booleanValueForKey:(NSString *) key defaultValue:(BOOL) defalutValue;

-(int) intValueForKey:(NSString *) key defaultValue:(int) defalutValue;

-(long) longValueForKey:(NSString *) key defaultValue:(long) defalutValue;

-(long long) longLongValueForKey:(NSString *) key defaultValue:(long long) defalutValue;

-(float) floatValueForKey:(NSString *) key defaultValue:(float) defalutValue;

-(double) doubleValueForKey:(NSString *) key defaultValue:(double) defalutValue;

-(id) objectValueForKey:(NSString *) key defaultValue:(id) defalutValue;



-(NSString *) stringValueForKeyPath:(NSString *) keyPath defaultValue:(NSString *) defalutValue;

-(BOOL) booleanValueForKeyPath:(NSString *) keyPath defaultValue:(BOOL) defalutValue;

-(int) intValueForKeyPath:(NSString *) keyPath defaultValue:(int) defalutValue;

-(long) longValueForKeyPath:(NSString *) keyPath defaultValue:(long) defalutValue;

-(long long) longLongValueForKeyPath:(NSString *) keyPath defaultValue:(long long) defalutValue;

-(float) floatValueForKeyPath:(NSString *) keyPath defaultValue:(float) defalutValue;

-(double) doubleValueForKeyPath:(NSString *) keyPath defaultValue:(double) defalutValue;

-(id) objectValueForKeyPath:(NSString *) key defaultValue:(id) defalutValue;


-(void) setObjectValue:(id) value forKey:(NSString *) key;

-(void) setObjectValue:(id) value forKeyPath:(NSString *) keyPath;

-(NSArray *) arrayValue;

-(NSDictionary *) dictionaryValue;

-(id) objectValueAtIndex:(NSUInteger) index;

@end
