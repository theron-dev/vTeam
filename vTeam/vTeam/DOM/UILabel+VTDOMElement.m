//
//  UILabel+VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 14-3-28.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "UILabel+VTDOMElement.h"

#import "UIView+VTDOMElement.h"

#import "VTDOMElement+Style.h"

@implementation UILabel (VTDOMElement)

-(void) setElement:(VTDOMElement *)element{
    [super setElement:element];
   
    self.font = [element fontValueForKey:@"font"];
    self.textColor = [element colorValueForKey:@"color"];
    
    NSTextAlignment alignment = NSTextAlignmentCenter;
    
    
    NSString * align = [element stringValueForKey:@"align"];
    
    if([align isEqualToString:@"left"]){
        alignment = NSTextAlignmentLeft;
    }
    else if([align isEqualToString:@"right"]){
        alignment = NSTextAlignmentRight;
    }
    
    self.textAlignment = alignment;
    
    self.text = [element stringValueForKey:@"text"];

}

@end
