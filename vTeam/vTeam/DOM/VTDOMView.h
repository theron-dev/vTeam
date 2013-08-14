//
//  VTDOMView.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTDOMElement+Render.h>

@interface VTDOMView : UIView

@property(nonatomic,retain) VTDOMElement * element;
@property(nonatomic,assign,getter = isAllowAutoLayout) BOOL allowAutoLayout;

@end
