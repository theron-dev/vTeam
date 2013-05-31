//
//  VTWindow.h
//  vTeam
//
//  Created by zhang hailong on 13-5-31.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPopWindow : UIWindow

@property(nonatomic,readonly,getter = isAnimating) BOOL animating;

+(VTPopWindow *) popWindow;

+(VTPopWindow *) topPopWindow;

-(void) showAnimated:(BOOL) animated;

-(void) closeAnimated:(BOOL) animated;

@end
