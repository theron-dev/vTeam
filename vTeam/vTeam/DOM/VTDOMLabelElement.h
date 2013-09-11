//
//  VTDOMLabelElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>

@interface VTDOMLabelElement : VTDOMElement

@property(nonatomic,readonly) UIFont * font;
@property(nonatomic,readonly) UIColor * textColor;
@property(nonatomic,readonly) NSLineBreakMode lineBreakMode;
@property(nonatomic,readonly) NSTextAlignment alignment;
@property(nonatomic,readonly) CGFloat minFontSize;

@end
