//
//  VTButton.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTAction.h>

@interface VTButton : UIButton<IVTAction>

@property(nonatomic,retain) UIColor * backgroundColorHighlighted;
@property(nonatomic,retain) UIColor * backgroundColorDisabled;
@property(nonatomic,retain) UIColor * backgroundColorSelected;

-(UIColor *) backgroundColorForState:(UIControlState) state;

-(void) setBackgroundColor:(UIColor *) backgroundColor forState:(UIControlState)state;

@end
