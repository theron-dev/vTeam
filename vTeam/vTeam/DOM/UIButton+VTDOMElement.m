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

    NSString * title = [element attributeValueForKey:@"title"];
   
    if(title){
        [self setTitle:title forState:UIControlStateNormal];
    }
    
    title = [element attributeValueForKey:@"title-highlighted"];
    
    if(title){
        [self setTitle:title forState:UIControlStateHighlighted];
    }

    title = [element attributeValueForKey:@"title-disabled"];
    
    if(title){
        [self setTitle:title forState:UIControlStateDisabled];
    }
    
    title = [element attributeValueForKey:@"title-selected"];
    
    if(title){
        [self setTitle:title forState:UIControlStateSelected];
    }
    
    UIColor * color =[element colorValueForKey:@"color"];
    
    if(color){
        [self setTitleColor:color forState:UIControlStateNormal];
    }
    
    color =[element colorValueForKey:@"color-highlighted"];
    
    if(color){
        [self setTitleColor:color forState:UIControlStateHighlighted];
    }
    
    color =[element colorValueForKey:@"color-disabled"];
    
    if(color){
        [self setTitleColor:color forState:UIControlStateDisabled];
    }
    
    color =[element colorValueForKey:@"color-selected"];
    
    if(color){
        [self setTitleColor:color forState:UIControlStateSelected];
    }
  
    UIImage * image = [element imageValueForKey:@"background-image" bundle:element.document.bundle];
    
    if(image){
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    image = [element imageValueForKey:@"background-image-highlighted" bundle:element.document.bundle];
    
    if(image){
        [self setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    
    image = [element imageValueForKey:@"background-image-disabled" bundle:element.document.bundle];
    
    if(image){
        [self setBackgroundImage:image forState:UIControlStateDisabled];
    }
    
    image = [element imageValueForKey:@"background-image-selected" bundle:element.document.bundle];
    
    if(image){
        [self setBackgroundImage:image forState:UIControlStateSelected];
    }
    
    image = [element imageValueForKey:@"image" bundle:element.document.bundle];
    
    if(image){
        [self setImage:image forState:UIControlStateNormal];
    }
    
    image = [element imageValueForKey:@"image-highlighted" bundle:element.document.bundle];
    
    if(image){
        [self setImage:image forState:UIControlStateHighlighted];
    }
    
    image = [element imageValueForKey:@"image-disabled" bundle:element.document.bundle];
    
    if(image){
        [self setImage:image forState:UIControlStateDisabled];
    }
    
    image = [element imageValueForKey:@"image-selected" bundle:element.document.bundle];
    
    if(image){
        [self setImage:image forState:UIControlStateSelected];
    }
    
    [self setSelected:[element booleanValueForKey:@"selected"]];
    
    [self setEnabled:![element booleanValueForKey:@"disabled"]];
    
    [self setAdjustsImageWhenDisabled:NO];
    
}

@end
