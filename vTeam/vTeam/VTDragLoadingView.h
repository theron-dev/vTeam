//
//  DragLoadingView.h
//  Sports
//
//  Created by zhang hailong on 13-4-7.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VTDragLoadingViewDirectDown,VTDragLoadingViewDirectUp,VTDragLoadingViewDirectLeft,VTDragLoadingViewDirectRight
} VTDragLoadingViewDirect;

@interface VTDragLoadingView : UIButton

@property (retain, nonatomic) IBOutlet UIImageView *directImageView;
@property (retain, nonatomic) IBOutlet UILabel *downTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *upTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (retain, nonatomic) IBOutlet UIView *loadingView;
@property (retain, nonatomic) IBOutlet UILabel *loadingTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign,getter = isAnimating) BOOL animating;
@property (assign,nonatomic) VTDragLoadingViewDirect direct;
@property (assign,nonatomic) CGFloat offsetValue;

-(void) startAnimation;

-(void) stopAnimation;

@end
