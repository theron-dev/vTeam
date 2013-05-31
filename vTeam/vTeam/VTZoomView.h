//
//  VTZoomView.h
//  vTeam
//
//  Created by zhang hailong on 13-5-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTAction.h>

@interface VTZoomView : UIControl<IVTAction>

@property(nonatomic,assign) CGFloat highlightedZoom;

@end
