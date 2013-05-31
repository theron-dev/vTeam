//
//  VTFormDateEditor.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTFormEditor.h>

@interface VTFormDateEditor : NSObject<IVTFormEditor>

@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,retain) IBOutlet UIDatePicker * datePicker;
@property(nonatomic,retain) NSString * dateFormat;

-(IBAction) doOKAction:(id)sender;

-(IBAction) doCancelAction:(id)sender;


@end
