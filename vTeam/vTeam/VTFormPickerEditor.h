//
//  VTFormPickerEditor.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTFormEditor.h>
#import <vTeam/VTFormPickerEditorItem.h>

@interface VTFormPickerEditor : NSObject<IVTFormEditor,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,assign) NSUInteger numberOfColumns;
@property(nonatomic,retain) IBOutletCollection(VTFormPickerEditorItem) NSArray * items;
@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,retain) IBOutlet UIPickerView * pickerView;

-(IBAction) doOKAction:(id)sender;

-(IBAction) doCancelAction:(id)sender;


@end
