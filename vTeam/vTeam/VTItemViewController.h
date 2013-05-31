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

@interface VTItemViewController : UIViewController

@property(nonatomic,retain) id userInfo;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,retain) NSString * reuseIdentifier;

@property(nonatomic,assign) id<IVTUIContext> context;
@property(nonatomic,retain) IBOutlet VTStyleOutletContainer * styleContainer;
@property(nonatomic,retain) IBOutlet VTDataOutletContainer * dataOutletContainer;
@property(nonatomic,retain) IBOutlet VTLayoutContainer * layoutContainer;
@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) id dataItem;

-(IBAction) doAction :(id)sender;

@end


@protocol VTItemViewControllerDelegate 

@optional

-(void) vtItemViewController:(VTItemViewController *) itemViewController doAction:(id) action;

@end