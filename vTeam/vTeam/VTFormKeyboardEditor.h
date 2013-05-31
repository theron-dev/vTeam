//
//  VTFormKeyboardEditor.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTFormEditor.h>
#import <vTeam/VTKeyboardController.h>

@interface VTFormKeyboardEditor : NSObject<IVTFormEditor,VTKeyboardControllerDelegate>

@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,retain) IBOutlet UILabel * tipLabel;
@property(nonatomic,retain) IBOutlet UILabel * lengthLabel;

-(IBAction) doCloseAction:(id)sender;

@end
