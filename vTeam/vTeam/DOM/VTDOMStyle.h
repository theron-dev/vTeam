//
//  VTDOMStyle.h
//  vTeam
//
//  Created by zhang hailong on 13-8-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTDOMStyle : NSObject

@property(nonatomic,retain) NSString * name;
@property(nonatomic,readonly) NSArray * allKeys;

-(void) setStringValue:(NSString *) value forKey:(NSString *) key;

-(NSString *) stringValueForKey:(NSString *) key;

-(float) floatValueForKey:(NSString *) key;

-(BOOL) booleanValueForKey:(NSString *) key;

-(UIImage *) imageValueForKey:(NSString *) key bundle:(NSBundle *) bundle;

-(UIColor *) colorValueForKey:(NSString *) key;

-(UIFont *) fontValueForKey:(NSString *) key;

+(float) floatValue:(NSString *) value;

+(BOOL) booleanValue:(NSString *) value;

+(UIImage *) imageValue:(NSString *) value bundle:(NSBundle *) bundle;

+(UIColor *) colorValue:(NSString *) value;

+(UIFont *) fontValue:(NSString *) value;

@end
