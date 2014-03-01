//
//  VTDOMElement+Frame.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMELement.h>

@interface VTDOMElement (Frame)

@property(nonatomic,assign) CGRect frame;

- (CGRect)convertRect:(CGRect)rect superElement:(VTDOMElement *) element;

- (void) elementDidFrameChanged:(VTDOMElement *) element;

@end
