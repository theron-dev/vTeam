//
//  VTFormItem.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTFormItemView.h>

@interface VTFormItem : NSObject<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,assign) NSUInteger length;
@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) NSString * editorType;
@property(nonatomic,retain) id value;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,readonly,getter = isEmpty) BOOL empty;
@property(nonatomic,assign,getter = isFocus) BOOL focus;
@property(nonatomic,retain) NSString * tip;
@property(nonatomic,retain) NSString * field;

-(IBAction) doFocusAction:(id)sender;

-(void) focusCancel;

@end

@protocol VTFormItemDelegate

@optional

-(void) vtFormItemOnFocusAction:(VTFormItem *) formItem;

-(void) vtFormItemOnFocusCancel:(VTFormItem *) formItem;

@end