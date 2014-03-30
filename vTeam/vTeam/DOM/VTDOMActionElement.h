//
//  VTDOMActionElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>

#import <vTeam/IVTAction.h>

@interface VTDOMActionElement : VTDOMElement<IVTAction>

@property(nonatomic,readonly,getter = isAllowLongTapAction) BOOL allowLongTapAction;

@end
