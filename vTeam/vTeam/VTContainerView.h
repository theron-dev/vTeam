//
//  VTContainerView.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTItemViewController.h>
#import <vTeam/VTContainerLayout.h>

@interface VTContainerView : UIScrollView

@property(nonatomic,retain) IBOutlet VTContainerLayout * containerLayout;
@property(nonatomic,retain) IBOutlet UIView * headerView;
@property(nonatomic,retain) IBOutlet UIView * footerView;
@property(nonatomic,retain) IBOutlet UIView * backgroundView;
@property(nonatomic,assign) NSInteger focusIndex;
@property(nonatomic,assign) UIEdgeInsets visableEdgeInsets;
@property(nonatomic,readonly,copy) NSArray * visableItemViewControllers;

-(BOOL) isFullVisableRect:(CGRect) rect;

-(BOOL) isVisableRect:(CGRect) rect;

-(VTItemViewController *) dequeueReusableItemViewWithIdentifier:(NSString * )reuseIdentifier;

-(void) reloadData;

-(CGRect) itemRectAtIndex:(NSInteger) index;

-(void) setFocusIndex:(NSInteger)focuseIndex animated:(BOOL) animated;

-(VTItemViewController *) itemViewControllerAtIndex:(NSInteger) index;

-(CGSize) innerSize;

@end

@protocol VTContainerViewDelegate <UIScrollViewDelegate>

-(VTItemViewController *) vtContainerView:(VTContainerView *) containerView itemViewAtIndex:(NSInteger) index frame:(CGRect) frame;

@optional

-(void) vtContainerView:(VTContainerView *) containerView didContentOffsetChanged:(CGPoint) contentOffset;

-(void) vtContainerViewDidLayout:(VTContainerView *) containerView;

-(void) vtContainerViewWillLayout:(VTContainerView *) containerView;

-(void) vtContainerView:(VTContainerView *)containerView didFocusIndexChanged:(NSInteger)focusIndex;

@end
