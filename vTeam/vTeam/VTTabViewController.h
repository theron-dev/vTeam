//
//  VTTabViewController.h
//  vTeam
//
//  Created by zhang hailong on 13-7-5.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTTabViewController : VTViewController

@property(nonatomic,retain) IBOutlet UIView * contentView;
@property(nonatomic,retain) IBOutlet UIView * tabView;
@property(nonatomic,retain) IBOutletCollection(UIButton) NSArray * tabButtons;
@property(nonatomic,readonly) UIViewController * selectedViewController;
@property(nonatomic,retain) NSArray * viewControllers;
@property(nonatomic,assign) NSUInteger selectedIndex;
@property(nonatomic,readonly) UIButton * selectedTabButton;

-(IBAction) doTabAction:(id) sender;

@end
