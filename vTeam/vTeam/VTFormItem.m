//
//  VTFormItem.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormItem.h"

@implementation VTFormItem

@synthesize view = _view;
@synthesize length = _length;
@synthesize delegate = _delegate;
@synthesize editorType = _editorType;
@synthesize focus = _focus;
@synthesize tip = _tip;
@synthesize field = _field;

-(void) dealloc{
    [_tip release];
    [_view release];
    [_editorType release];
    [_field release];
    [super dealloc];
}

-(id) value{
    
    if([_view conformsToProtocol:@protocol(IVTFormItemView)]){
        return [(id<IVTFormItemView>)_view value];
    }
    
    if([_view isKindOfClass:[UILabel class]]){
        return [(UILabel *)_view text];
    }
    
    if([_view isKindOfClass:[UITextView class]]){
        return [(UITextView *)_view text];
    }
    
    if([_view isKindOfClass:[UIButton class]]){
        return [(UIButton *)_view titleForState:UIControlStateNormal];
    }
    
    return nil;
}

-(NSString *) text{
    
    if([_view conformsToProtocol:@protocol(IVTFormItemView)]){
        return [(id<IVTFormItemView>)_view text];
    }
    
    if([_view isKindOfClass:[UILabel class]]){
        return [(UILabel *)_view text];
    }
    
    if([_view isKindOfClass:[UITextView class]]){
        return [(UITextView *)_view text];
    }
    
    if([_view isKindOfClass:[UIButton class]]){
        return [(UIButton *)_view titleForState:UIControlStateNormal];
    }
    return nil;
}

-(void) setValue:(id)value{
    
    
    if([_view conformsToProtocol:@protocol(IVTFormItemView)]){
        [(id<IVTFormItemView>)_view setValue:value];
    }
    
    if([value isKindOfClass:[NSString class]]){
        if([_view isKindOfClass:[UILabel class]]){
            [(UILabel *)_view setText:value];
        }
        
        if([_view isKindOfClass:[UITextView class]]){
            [(UITextView *)_view setText:value];
        }
        
        if([_view isKindOfClass:[UIButton class]]){
            [(UIButton *) _view setTitle:value forState:UIControlStateNormal];
        }
    }
}

-(void) setText:(NSString *)text{
    
    if([_view conformsToProtocol:@protocol(IVTFormItemView)]){
        [(id<IVTFormItemView>)_view setText:text];
    }
    
    if([_view isKindOfClass:[UILabel class]]){
        [(UILabel *)_view setText:text];
    }
    
    if([_view isKindOfClass:[UITextView class]]){
        [(UITextView *)_view setText:text];
    }
    
    if([_view isKindOfClass:[UIButton class]]){
        [(UIButton *) _view setTitle:text forState:UIControlStateNormal];
    }
}

-(IBAction) doFocusAction:(id)sender{
    [_view becomeFirstResponder];
    if([_delegate respondsToSelector:@selector(vtFormItemOnFocusAction:)]){
        [_delegate vtFormItemOnFocusAction:self];
    }
}

-(BOOL) isEmpty{
    id v = [self value];
    if(v == nil){
        return YES;
    }
    if([v isKindOfClass:[NSString class]]){
        return [v length] == 0;
    }
    if([v isKindOfClass:[NSNumber class]]){
        return [v doubleValue] == 0.0;
    }
    if([v isKindOfClass:[NSNull class]]){
        return YES;
    }
    if([v isKindOfClass:[NSDate class]]){
        return [v timeIntervalSince1970] == 0.0;
    }
    return NO;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if(_view == textField){
        if([_delegate respondsToSelector:@selector(vtFormItemOnFocusAction:)]){
            [_delegate vtFormItemOnFocusAction:self];
        }
    }
    return YES;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    if(_view == textView){
        if([_delegate respondsToSelector:@selector(vtFormItemOnFocusAction:)]){
            [_delegate vtFormItemOnFocusAction:self];
        }
    }
    return YES;
}

-(void) focusCancel{
    [_view resignFirstResponder];
    if([_delegate respondsToSelector:@selector(vtFormItemOnFocusCancel:)]){
        [_delegate vtFormItemOnFocusCancel:self];
    }
}

@end
