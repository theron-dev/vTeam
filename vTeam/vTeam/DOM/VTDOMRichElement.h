//
//  VTDOMRichElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>

#import <vTeam/IVTAction.h>
#import <vTeam/VTRich.h>

@interface VTDOMRichElement : VTDOMElement<IVTAction,VTDOMElementDelegate>

@property(nonatomic,readonly) UIFont * font;
@property(nonatomic,readonly) UIColor * textColor;
@property(nonatomic,retain) VTRich * rich;

@end
