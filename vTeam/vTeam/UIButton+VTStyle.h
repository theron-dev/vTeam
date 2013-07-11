//
//  UIButton+VTStyle.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (VTStyle)

@property(nonatomic,retain) UIImage * backgroundImage;
@property(nonatomic,retain) UIImage * backgroundImageHighlighted;
@property(nonatomic,retain) UIImage * backgroundImageDisabled;
@property(nonatomic,retain) UIImage * backgroundImageSelected;
@property(nonatomic,retain) NSString * title;
@property(nonatomic,retain) UIColor * textColor;
@property(nonatomic,retain) UIColor * textColorHighlighted;
@property(nonatomic,retain) UIColor * textColorDisabled;
@property(nonatomic,retain) UIColor * textColorSelected;
@property(nonatomic,retain) UIColor * titleColor;
@property(nonatomic,retain) UIColor * titleColorHighlighted;
@property(nonatomic,retain) UIColor * titleColorDisabled;
@property(nonatomic,retain) UIColor * titleColorSelected;
@property(nonatomic,retain) UIImage * image;
@property(nonatomic,retain) UIImage * imageHighlighted;
@property(nonatomic,retain) UIImage * imageDisabled;
@property(nonatomic,retain) UIImage * imageSelected;

@end
