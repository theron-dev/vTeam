//
//  UIButton+VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 13-11-29.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIButton+VTDOMElement.h"

#import "UIView+VTDOMElement.h"

#import "VTDOMElement+Style.h"

#import "VTDOMDocument.h"

@implementation UIButton (VTDOMElement)


-(void) setElement:(VTDOMElement *)element{
    [super setElement:element];
    
    [self.titleLabel setFont:[element fontValueForKey:@"font"]];
    
    [self setContentEdgeInsets:[element edgeInsetsValueForKey:@"content-edge-insets"]];
    
    [self setImageEdgeInsets:[element edgeInsetsValueForKey:@"image-edge-insets"]];
    
    [self setTitleEdgeInsets:[element edgeInsetsValueForKey:@"title-edge-insets"]];

    [self setTitle:[element attributeValueForKey:@"title"] forState:UIControlStateNormal];
    [self setTitle:[element attributeValueForKey:@"title-highlighted"] forState:UIControlStateHighlighted];
    [self setTitle:[element attributeValueForKey:@"title-disabled"] forState:UIControlStateDisabled];
    [self setTitle:[element attributeValueForKey:@"title-selected"] forState:UIControlStateSelected];
    
    [self setTitleColor:[element colorValueForKey:@"color"] forState:UIControlStateNormal];
    [self setTitleColor:[element colorValueForKey:@"color-highlighted"] forState:UIControlStateHighlighted];
    [self setTitleColor:[element colorValueForKey:@"color-disabled"] forState:UIControlStateDisabled];
    [self setTitleColor:[element colorValueForKey:@"color-selected"] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[element imageValueForKey:@"background-image" bundle:element.document.bundle] forState:UIControlStateNormal];
    [self setBackgroundImage:[element imageValueForKey:@"background-image-highlighted" bundle:element.document.bundle] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[element imageValueForKey:@"background-image-disabled" bundle:element.document.bundle] forState:UIControlStateDisabled];
    [self setBackgroundImage:[element imageValueForKey:@"background-image-selected" bundle:element.document.bundle] forState:UIControlStateSelected];
    
    [self setImage:[element imageValueForKey:@"image" bundle:element.document.bundle] forState:UIControlStateNormal];
    [self setImage:[element imageValueForKey:@"image-highlighted" bundle:element.document.bundle] forState:UIControlStateHighlighted];
    [self setImage:[element imageValueForKey:@"image-disabled" bundle:element.document.bundle] forState:UIControlStateDisabled];
    [self setImage:[element imageValueForKey:@"image-selected" bundle:element.document.bundle] forState:UIControlStateSelected];
    

    [self setSelected:[element booleanValueForKey:@"selected"]];
    
    [self setEnabled:![element booleanValueForKey:@"disabled"]];
    
    [self setAdjustsImageWhenDisabled:NO];
    
}

@end
