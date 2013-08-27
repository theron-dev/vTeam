//
//  VTItemViewController.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTStyleOutletContainer.h>
#import <vTeam/VTDataOutletContainer.h>
#import <vTeam/IVTUIContext.h>
#import <vTeam/IVTAction.h>
#import <vTeam/VTLayoutContainer.h>
#import <vTeam/VTDataSource.h>

@interface VTItemViewController : UIViewController<VTDataSourceDelegate>

@property(nonatomic,retain) id userInfo;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,retain) NSString * reuseIdentifier;

@property(nonatomic,assign) id<IVTUIContext> context;
@property(nonatomic,retain) IBOutlet VTStyleOutletContainer * styleContainer;
@property(nonatomic,retain) IBOutlet VTDataOutletContainer * dataOutletContainer;
@property(nonatomic,retain) IBOutlet VTLayoutContainer * layoutContainer;
@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) id dataItem;
@property(nonatomic,assign) CGSize itemSize;
@property(nonatomic,retain) IBOutlet VTDataSource * dataSource;

-(IBAction) doAction :(id)sender;

-(void) downloadImagesForView:(UIView *) view;

-(void) loadImagesForView:(UIView *) view;

-(void) cancelDownloadImagesForView:(UIView *) view;

@end


@protocol VTItemViewControllerDelegate 

@optional

-(void) vtItemViewController:(VTItemViewController *) itemViewController doAction:(id) action;

@end