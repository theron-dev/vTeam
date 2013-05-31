//
//  VTFormDateEditor.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormDateEditor.h"

@interface VTFormDateEditor()

@property(nonatomic,readonly) NSDateFormatter * dateFormatter;

@end

@implementation VTFormDateEditor

@synthesize formItem = _formItem;
@synthesize view = _view;
@synthesize datePicker = _datePicker;
@synthesize dateFormatter = _dateFormatter;
@synthesize editorType = _editorType;

-(id) init{
    if((self = [super init])){
        [self setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

-(void) dealloc{
    [_dateFormatter release];
    [_formItem release];
    [_view release];
    [_datePicker release];
    [_editorType release];
    [super dealloc];
}

-(void) setFormItem:(VTFormItem *)formItem{
    if(_formItem != formItem){
        [formItem retain];
        [_formItem release];
        _formItem = formItem;
        
        [_view setHidden: _formItem == nil];
        
        if(_formItem){
            
            id v = [_formItem value];
            
            if([v isKindOfClass:[NSDate class]]){
                [_datePicker setDate:v];
            }
            else if([v isKindOfClass:[NSString class]]){
                [_datePicker setDate:[_dateFormatter dateFromString:v]];
            }
            else {
                [_datePicker setDate:[NSDate date]];
            }
            
            [_view.superview bringSubviewToFront:_view];
            
        }
    }
}


-(NSString *) dateFormat{
    return [_dateFormatter dateFormat];
}

-(void) setDateFormat:(NSString *)dateFormat{
    if(_dateFormatter == nil){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    [_dateFormatter setDateFormat:dateFormat];
}

-(IBAction) doOKAction:(id)sender{
    [_formItem setValue:[_datePicker date]];
    [_formItem setText:[_dateFormatter stringFromDate:[_datePicker date]]];
    [_formItem focusCancel];
}

-(IBAction) doCancelAction:(id)sender{
    [_formItem focusCancel];
}

@end
