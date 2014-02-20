//
//  UIControl+VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 14-2-20.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "UIControl+VTDOMElement.h"

#import "UIView+VTDOMElement.h"

#import "VTDOMElement+Style.h"

#import "VTDOMDocument.h"

@implementation UIControl (VTDOMElement)


-(void) setElement:(VTDOMElement *)element{
    [super setElement:element];
    
    UIControlContentHorizontalAlignment align = UIControlContentHorizontalAlignmentCenter;
    
    NSString * s = [element stringValueForKey:@"align"];
    
    if([s isEqualToString:@"left"]){
        align = UIControlContentHorizontalAlignmentLeft;
    }
    else if([s isEqualToString:@"right"]){
        align = UIControlContentHorizontalAlignmentRight;
    }
    
    [self setContentHorizontalAlignment:align];
    
    UIControlContentVerticalAlignment valign = UIControlContentVerticalAlignmentCenter;
    
    s = [element stringValueForKey:@"valign"];
    
    if([s isEqualToString:@"top"]){
        valign = UIControlContentVerticalAlignmentTop;
    }
    else if([s isEqualToString:@"bottom"]){
        valign = UIControlContentVerticalAlignmentBottom;
    }
    
    [self setContentVerticalAlignment:valign];
    
}

@end
