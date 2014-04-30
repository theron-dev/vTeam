//
//  VTTabDataController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-7-7.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataController.h>

@interface VTTabDataController : VTDataController{
    
@protected
    NSUInteger _selectedIndex;
}

@property(nonatomic,retain) IBOutletCollection(VTDataController) NSArray * controllers;
@property(nonatomic,retain) IBOutletCollection(UIButton) NSArray * tabButtons;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * contentViews;
@property(nonatomic,readonly) id selectedController;
@property(nonatomic,readonly) id selectedTabButton;
@property(nonatomic,readonly) id selectedContentView;

@property(nonatomic,assign) NSUInteger selectedIndex;

-(IBAction) doTabAction:(id)sender;

@end

@protocol VTTabDataControllerDelegate <VTDataControllerDelegate>

@optional

-(BOOL) vtTabDataController:(VTTabDataController *) dataController willSelectedChanged:(NSUInteger) selectedIndex;

-(void) vtTabDataController:(VTTabDataController *) dataController didSelectedChanged:(NSUInteger) selectedIndex;

@end