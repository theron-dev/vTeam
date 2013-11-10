//
//  VTDOMElement+Render.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement+Frame.h>

@interface VTDOMElement (Render)

@property(nonatomic,readonly,getter = isHidden) BOOL hidden;

-(void) render:(CGRect) rect context:(CGContextRef) context;

-(void) draw:(CGRect) rect context:(CGContextRef) context;

@end
