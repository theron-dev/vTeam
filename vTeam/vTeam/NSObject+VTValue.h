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

@end
