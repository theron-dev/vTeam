//
//  IGridCell.h
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IGridDraw.h>

@protocol IGridCell <IGridDraw>

@property(nonatomic,retain) NSString * title;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,retain) UIColor * titleColor;
@property(nonatomic,retain) UIFont * titleFont;
@property(nonatomic,assign) CGFloat titleMinFontSize;
@property(nonatomic,assign) UITextAlignment titleAlignment;
@property(nonatomic,retain) UIColor * backgroundColor;
@property(nonatomic,retain) NSString * keyPath;
@property(nonatomic,assign,getter = isClipsLastTitle) BOOL clipsLastTitle;
@property(nonatomic,assign) NSUInteger colSpan;
@property(nonatomic,retain) UIView * view;

@end
