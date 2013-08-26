//
//  VTDOMElement+Control.h
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement+Frame.h>

@interface VTDOMElement (Control)

@property(nonatomic,assign,getter = isEnabled) BOOL enabled;
@property(nonatomic,assign,getter = isHighlighted) BOOL highlighted;
@property(nonatomic,assign,getter = isSelected) BOOL selected;

- (BOOL)touchesBegan:(CGPoint) location;
- (void)touchesMoved:(CGPoint) location;
- (void)touchesEnded:(CGPoint) location;
- (void)touchesCancelled:(CGPoint) location;

@end
