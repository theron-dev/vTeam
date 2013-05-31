//
//  VTFormController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTFormItem.h>
#import <vTeam/IVTFormEditor.h>

@interface VTFormController : NSObject<VTFormItemDelegate>

@property(nonatomic,retain) VTFormItem * focusFormItem;
@property(nonatomic,retain) id<IVTFormEditor> focusEditor;
@property(nonatomic,retain) IBOutletCollection(VTFormItem) NSArray * formItems;
@property(nonatomic,retain) IBOutletCollection(id) NSArray * editors;

@property(nonatomic,copy) id formValues;

@end