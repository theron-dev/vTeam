//
//  VTPageDataController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataController.h>
#import <vTeam/VTContainerView.h>
#import <vTeam/VTDragLoadingView.h>
#import <vTeam/VTItemViewController.h>


@interface VTPageDataController : VTDataController<VTContainerViewDelegate,VTContainerLayoutDelegate,VTItemViewControllerDelegate>


@property(nonatomic,retain) IBOutlet VTContainerView * containerView;
@property(nonatomic,retain) NSString * itemViewNib;
@property(nonatomic,retain) NSString * itemViewClass;
@property(nonatomic,retain) NSBundle * itemViewBundle;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * leftLoadingView;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * rightLoadingView;
@property(nonatomic,retain) IBOutlet UIPageControl * pageControl;
@property(nonatomic,readonly) NSInteger pageIndex;
@property(nonatomic,readonly) NSInteger pageCount;

-(void) setPageIndex:(NSInteger)pageIndex animated:(BOOL) animated;

-(void) startLoading;

-(void) stopLoading;

@end

@protocol VTPageDataControllerDelegate <VTDataControllerDelegate>

@optional

-(void) vtPageDataController:(VTPageDataController *) dataController itemViewController:(VTItemViewController *) itemViewController doAction:(id<IVTAction>) action;

-(void) vtPageDataControllerLeftAction:(VTPageDataController *)dataController;

-(void) vtPageDataControllerRightAction:(VTPageDataController *)dataController;

-(BOOL) vtPageDataControllerShowLeftLoading:(VTPageDataController *) dataController;

-(BOOL) vtPageDataControllerShowRightLoading:(VTPageDataController *) dataController;

-(void) vtPageDataController:(VTPageDataController *)dataController focusIndexChanged:(NSInteger) focusIndex;

@end
