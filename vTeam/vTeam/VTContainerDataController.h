//
//  VTContainerDataController.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataController.h>

#import <vTeam/VTContainerView.h>
#import <vTeam/VTDragLoadingView.h>
#import <vTeam/VTItemViewController.h>
#import <vTeam/VTFallsContainerLayout.h>


@interface VTContainerDataController : VTDataController<VTContainerViewDelegate,VTContainerLayoutDelegate,VTItemViewControllerDelegate,VTFallsContainerLayoutDelegate>

@property(nonatomic,retain) IBOutlet VTContainerView * containerView;
@property(nonatomic,retain) NSString * itemViewNib;
@property(nonatomic,retain) NSString * itemViewClass;
@property(nonatomic,retain) NSBundle * itemViewBundle;
@property(nonatomic,retain) NSString * reseIdentifier;
@property(nonatomic,assign) CGSize itemSize;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * topLoadingView;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * bottomLoadingView;
@property(nonatomic,retain) IBOutlet UIView * notFoundDataView;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * autoHiddenViews;
@property(nonatomic,retain) IBOutletCollection(VTItemViewController) NSArray * headerItemViewControllers;
@property(nonatomic,retain) IBOutletCollection(VTItemViewController) NSArray * footerItemViewControllers;

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath;

@end

@protocol VTContainerDataControllerDelegate <VTDataControllerDelegate>

@optional

-(void) vtContainerDataController:(VTContainerDataController *) dataController itemViewController:(VTItemViewController *) itemViewController doAction:(id<IVTAction>) action;

@end