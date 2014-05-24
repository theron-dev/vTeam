//
//  UIView+VTDOMElement.h
//  vTeam
//
//  Created by zhang hailong on 13-11-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTDOMElement.h>

@interface UIView (VTDOMElement)

-(void) setElement:(VTDOMElement *) element;

-(void) element:(VTDOMElement *) element attributeChangedValue:(NSString *) value forKey:(NSString *) key;

-(void) element:(VTDOMElement *) element valueChangedValue:(id)value forKey:(NSString *)key;

@end
