//
//  VTKeyboardController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTController.h>

@interface VTKeyboardController : VTController

@end

@protocol VTKeyboardControllerDelegate

@optional

-(void) vtKeyboardController:(VTKeyboardController * )controller willShowFrame:(CGRect) frame;
-(void) vtKeyboardController:(VTKeyboardController * )controller didShowFrame:(CGRect) frame;
-(void) vtKeyboardController:(VTKeyboardController * )controller willHideFrame:(CGRect) frame;
-(void) vtKeyboardController:(VTKeyboardController * )controller didHideFrame:(CGRect) frame;
-(void) vtKeyboardController:(VTKeyboardController * )controller willChangedFrame:(CGRect) frame;
-(void) vtKeyboardController:(VTKeyboardController * )controller didChangedFrame:(CGRect) frame;

@end