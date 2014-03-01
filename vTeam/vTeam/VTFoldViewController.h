//
//  VTFoldViewController.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTViewController.h>

extern NSString * VTFoldViewControllerToCenterNotification;

@interface VTFoldViewController : VTViewController<UIGestureRecognizerDelegate>

@property(nonatomic,readonly,getter = isAnimating) BOOL animating;
@property(nonatomic,readonly,getter=isDragging)    BOOL dragging;

@end
