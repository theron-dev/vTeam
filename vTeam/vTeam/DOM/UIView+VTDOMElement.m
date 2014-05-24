//
//  UIView+VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 13-11-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIView+VTDOMElement.h"

#import <vTeam/VTDOMElement+Style.h>
#import <vTeam/VTDOMElement+Render.h>

#import <QuartzCore/QuartzCore.h>

@implementation UIView (VTDOMElement)

-(void) setElement:(VTDOMElement *) element{
    self.backgroundColor = [element colorValueForKey:@"background-color"];
    self.layer.cornerRadius = [element floatValueForKey:@"corner-radius"];
    self.layer.borderWidth = [element floatValueForKey:@"border-width"];
    self.layer.borderColor = [element colorValueForKey:@"border-color"].CGColor;
    self.layer.masksToBounds = self.layer.borderWidth > 0.0f;
    if(!self.layer.masksToBounds){
        self.layer.masksToBounds = [element booleanValueForKey:@"clips"];
    }
    [self setHidden:[element isHidden]];
}

-(void) element:(VTDOMElement *) element attributeChangedValue:(NSString *) value forKey:(NSString *) key{
    
    
    if([key isEqualToString:@"hidden"] || [key isEqualToString:@"visable"]){
        [self setHidden:[element isHidden]];
    }
    
}

-(void) element:(VTDOMElement *) element valueChangedValue:(id) value forKey:(NSString *)key{
    
}

@end
