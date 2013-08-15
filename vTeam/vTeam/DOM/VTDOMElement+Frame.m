//
//  VTDOMElement+Frame.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Frame.h"

@implementation VTDOMElement (Frame)

-(CGRect) frame{
    return [[self valueForKey:@"frame"] CGRectValue];
}

-(void) setFrame:(CGRect)frame{
    [self setValue:[NSValue valueWithCGRect:frame] forKey:@"frame"];
}

- (CGRect)convertRect:(CGRect)rect superElement:(VTDOMElement *) element{
    
    VTDOMElement * el = self;
    
    while(el != element){
        
        CGRect r = el.frame;
        
        rect.origin = CGPointMake(rect.origin.x + r.origin.x, rect.origin.y + r.origin.y);
        
        rect = CGRectIntersection(rect, r);
        
        el = [el parentElement];
    }
    
    return rect;
}

@end
