//
//  VTFormPickerEditor.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormPickerEditor.h"

@interface VTFormPickerEditor(){
    NSMutableArray * _selectedIndexs;
}

-(NSInteger) selectedIndex:(NSInteger) component;

-(void) setSelectedIndex:(NSInteger) row component:(NSInteger) component;

-(VTFormPickerEditorItem *) itemAtIndex:(NSInteger) row component:(NSInteger) component;

-(VTFormPickerEditorItem *) selectedItem;

-(void) setSelectedValue:(id) value;

@end

@implementation VTFormPickerEditor

@synthesize formItem = _formItem;
@synthesize editorType = _editorType;
@synthesize items = _items;
@synthesize numberOfColumns = _numberOfColumns;
@synthesize view = _view;
@synthesize pickerView = _pickerView;

-(void) dealloc{
    [_view release];
    [_pickerView release];
    [_formItem release];
    [_editorType release];
    [_items release];
    [_selectedIndexs release];
    [super dealloc];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _numberOfColumns;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray * items = _items;
    for(int i=0;i<component;i++){
        NSInteger index = [self selectedIndex:i];
        if(index < [items count]){
            items = [[items objectAtIndex:index] items];
        }
        else{
            return 0;
        }
    }
    return [items count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self itemAtIndex:row component:component] text];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self setSelectedIndex:row component:component];
    [pickerView reloadAllComponents];
}

-(NSInteger) selectedIndex:(NSInteger) component{
    if(_selectedIndexs == nil){
        _selectedIndexs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    while([_selectedIndexs count] <= component){
        [_selectedIndexs addObject:[NSNumber numberWithInt:0]];
    }
    
    return [[_selectedIndexs objectAtIndex:component] intValue];
}

-(void) setSelectedIndex:(NSInteger) row component:(NSInteger) component{
    if(_selectedIndexs == nil){
        _selectedIndexs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    while([_selectedIndexs count] <= component){
        [_selectedIndexs addObject:[NSNumber numberWithInt:0]];
    }
    
    [_selectedIndexs replaceObjectAtIndex:component withObject:[NSNumber numberWithLong:row]];
}

-(VTFormPickerEditorItem *) itemAtIndex:(NSInteger) row component:(NSInteger) component{
    NSArray * items = _items;
    for(int i=0;i<component;i++){
        NSInteger index = [self selectedIndex:i];
        if(index < [items count]){
            items = [[items objectAtIndex:index] items];
        }
        else{
            return nil;
        }
    }
    if(row < [items count]){
        return [items objectAtIndex:row];
    }
    return nil;
}

-(void) setFormItem:(VTFormItem *)formItem{
    if(_formItem != formItem){
        [formItem retain];
        [_formItem release];
        _formItem = formItem;
        
        [_view setHidden: _formItem == nil];
        
        if(_formItem){
            
            id v = [_formItem value];
            
            [self setSelectedValue:v];
            
            [_view.superview bringSubviewToFront:_view];
            
        }
    }
}


-(IBAction) doOKAction:(id)sender{
    VTFormPickerEditorItem * item = [self selectedItem];
    [_formItem setValue:[item value]];
    [_formItem setText:[item text]];
    [_formItem focusCancel];
}

-(IBAction) doCancelAction:(id)sender{
    [_formItem focusCancel];
}

-(void) setSelectedValue:(id) value{
    if(_selectedIndexs == nil){
        _selectedIndexs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    else{
        [_selectedIndexs removeAllObjects];
    }
    
    NSInteger row =0;
    NSArray * items = _items;
    
    for (VTFormPickerEditorItem * item in items) {
        if([item value] == value){
            [_selectedIndexs addObject:[NSNumber numberWithLong:row]];
            [_pickerView selectRow:row inComponent:0 animated:NO];
            return;
        }
        row ++;
    }
   
    [_pickerView reloadAllComponents];
    
}

-(VTFormPickerEditorItem *) selectedItem{
    
    VTFormPickerEditorItem * item = nil;
    NSArray * items = _items;
    for(id v in _selectedIndexs){
        int index = [v intValue];
        if(index < [items count]){
            item = [items objectAtIndex:index];
            items = [item items];
        }
        else{
            break;
        }
    }
    
    while(items && [items count] >0){
        item = [items objectAtIndex:0];
        items = [item items];
    }
    
    return item;

}
@end
