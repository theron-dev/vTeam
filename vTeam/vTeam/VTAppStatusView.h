//
//  VTAppStatusView.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTAppStatusView : UIWindow

-(void) show:(BOOL) animated;

-(void) show:(BOOL) animated duration:(NSTimeInterval) duration;

-(void) close:(BOOL) animated;

@end

@interface VTAppStatusMessageView : VTAppStatusView

-(id) initWithTitle:(NSString *) title;



@end