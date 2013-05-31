//
//  VTFormKeyboardEditor.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormKeyboardEditor.h"

@implementation VTFormKeyboardEditor

@synthesize editorType = _editorType;
@synthesize formItem = _formItem;
@synthesize view = _view;
@synthesize tipLabel = _tipLabel;
@synthesize lengthLabel = _lengthLabel;

-(void) dealloc{
    [_editorType release];
    [_lengthLabel release];
    [_tipLabel release];
    [_view release];
    [_formItem release];
    [super dealloc];
}

-(IBAction) doCloseAction:(id)sender{
    [_formItem focusCancel];
}

-(void) setFormItem:(VTFormItem *)formItem{
    if(_formItem != formItem){
        if(formItem == nil){
            [[_formItem view] resignFirstResponder];
        }
        [formItem retain];
        [_formItem release];
        _formItem = formItem;
        [_tipLabel setText:[_formItem tip]];
        [_view setHidden:_formItem == nil];
    }
}

-(void) vtKeyboardController:(VTKeyboardController * )controller willShowFrame:(CGRect) frame{
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    CGRect r = [_view frame];
    
    r.origin.x = 0;
    r.origin.y = keyWindow.bounds.size.height - r.size.height;
    r.size.width = frame.size.width;
    
    [_view setFrame:r];
    
    if(_view.superview != keyWindow){
        [keyWindow addSubview:_view];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    r.origin.y = keyWindow.bounds.size.height - frame.size.height - r.size.height;
    
    [_view setFrame:r];
    
    [UIView commitAnimations];
    
}

-(void) vtKeyboardController:(VTKeyboardController * )controller willHideFrame:(CGRect) frame{
    [_view removeFromSuperview];
}

-(void) vtKeyboardController:(VTKeyboardController * )controller willChangedFrame:(CGRect) frame{
    
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    CGRect r = [_view frame];
    
    r.origin.x = 0;
    r.origin.y = keyWindow.bounds.size.height - frame.size.height - r.size.height;
    r.size.width = frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [_view setFrame:r];
    
    [UIView commitAnimations];
}

@end
