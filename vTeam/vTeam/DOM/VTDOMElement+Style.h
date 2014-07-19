//
//  VTDOMElement+Style.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>

@interface VTDOMElement (Style)

-(NSString *) stringValueForKey:(NSString *) key;

-(float) floatValueForKey:(NSString *) key;

-(BOOL) booleanValueForKey:(NSString *) key;

-(UIImage *) imageValueForKey:(NSString *) key bundle:(NSBundle *) bundle;

-(UIColor *) colorValueForKey:(NSString *) key;

-(UIFont *) fontValueForKey:(NSString *) key;

-(UIEdgeInsets) edgeInsetsValueForKey:(NSString *) key;

-(float) floatValueForKey:(NSString *) key of:(CGFloat) baseValue defaultValue:(CGFloat) defaultValue;

-(UIFont *) elementFont:(UIFont *) defaultFont;

@end
