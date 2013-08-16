//
//  VTDOMScrollView.h
//  vTeam
//
//  Created by zhang hailong on 13-8-16.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTDOMElement+Render.h>

@interface VTDOMScrollView : UIScrollView<VTDOMElementDelegate>

@property(nonatomic,assign) CGFloat pageScale;
@property(nonatomic,retain) VTDOMElement * element;

@end
