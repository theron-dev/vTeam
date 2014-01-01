//
//  VTDOMViewElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>
#import <vTeam/IVTAction.h>

@interface VTDOMViewElement : VTDOMElement<IVTAction>

@property(nonatomic,retain) UIView * view;

@property(nonatomic,readonly,getter = isViewLoaded) BOOL viewLoaded;

-(Class) viewClass;

@end
