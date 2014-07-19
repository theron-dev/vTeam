//
//  UIView+VTStyle.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VTStyle)

@property(nonatomic,assign) CGFloat cornerRadius;
@property(nonatomic,retain) UIColor * shadowColor;
@property(nonatomic,assign) float shadowOpacity;
@property(nonatomic,assign) CGSize shadowOffset;
@property(nonatomic,assign) CGFloat shadowRadius;
@property(nonatomic,retain) UIImage * backgroundImage;
@property(nonatomic,retain) UIColor * borderColor;
@property(nonatomic,assign) float borderWidth;
@property(nonatomic,retain) NSString * fontName;

@end
