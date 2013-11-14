//
//  VTAlertView.h
//  vTeam
//
//  Created by zhang hailong on 13-11-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTAlertView : UIView

-(id) initWithTitle:(NSString *) title font:(UIFont *)font size:(CGSize) size edgeInsets:(UIEdgeInsets) edgeInsets;

-(id) initWithTitle:(NSString *) title;

-(id) initWithTitle:(NSString *) title edgeInsets:(UIEdgeInsets)edgeInsets;

-(void) showDuration:(NSTimeInterval) duration;

-(void) show;

-(void) close;

@end
