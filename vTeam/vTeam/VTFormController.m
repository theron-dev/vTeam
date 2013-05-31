//
//  VTFormController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormController.h"

@implementation VTFormController

@synthesize focusEditor = _focusEditor;
@synthesize formItems = _formItems;
@synthesize focusFormItem = _focusFormItem;
@synthesize editors = _editors;

-(void) dealloc{
    [_formItems release];
    [_editors release];
    [_focusEditor release];
    [_focusFormItem release];
    [super dealloc];
}

-(id) formValues{
    NSMutableDictionary * values = [NSMutableDictionary dictionaryWithCapacity:4];
    for(VTFormItem * formItem in _formItems){
        if([formItem field]){
            [values setValue:[formItem value] forKey:[formItem field]];
        }
    }
    return values;
}

-(void) setFormValues:(id)formValues{
    for(VTFormItem * formItem in _formItems){
        if([formItem field]){
            [formItem setValue:[formValues valueForKey:[formItem field]]];
        }
    }
}

-(void) vtFormItemOnFocusAction:(VTFormItem *)formItem{
    for(VTFormItem * item in _formItems){
        [item setFocus:item == formItem];
    }
    self.focusFormItem = formItem;
    if(_focusFormItem){
        for(id editor in _editors){
            if([formItem.editorType isEqualToString:[editor editorType]]){
                [editor setFormItem:_focusFormItem];
                if(_focusEditor != editor){
                    [_focusEditor setFormItem:nil];
                }
                self.focusEditor = editor;
                break;
            }
        }
    }
    else{
        [_focusEditor setFormItem:nil];
        self.focusEditor = nil;
    }
}

-(void) vtFormItemOnFocusCancel:(VTFormItem *)formItem{
    if(self.focusFormItem == formItem){
        [formItem setFocus:NO];
        self.focusFormItem = nil;
        [_focusEditor setFormItem:nil];
        self.focusEditor = nil;
    }
}

@end
