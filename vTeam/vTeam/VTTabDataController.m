//
//  VTTabDataController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-7-7.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabDataController.h"

@implementation VTTabDataController

@synthesize controllers = _controllers;
@synthesize tabButtons = _tabButtons;
@synthesize contentViews = _contentViews;
@synthesize selectedIndex = _selectedIndex;

-(void) dealloc{
    [_controllers release];
    [_tabButtons release];
    [_contentViews release];
    [super dealloc];
}

-(id) selectedController{
    
    if(_selectedIndex < [_controllers count]){
        return [_controllers objectAtIndex:_selectedIndex];
    }
    
    return nil;
}

-(id) selectedContentView{
    
    if(_selectedIndex < [_contentViews count]){
        return [_contentViews objectAtIndex:_selectedIndex];
    }
    
    return nil;
}

-(id) selectedTabButton{
    
    if(_selectedIndex < [_tabButtons count]){
        return [_tabButtons objectAtIndex:_selectedIndex];
    }
    
    return nil;
}

-(NSUInteger) selectedIndex{
    return _selectedIndex;
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    if(_selectedIndex != selectedIndex){
        
        id delegate = [self delegate];
        
        if([delegate respondsToSelector:@selector(vtTabDataController:willSelectedChanged:)]){
            if(![delegate vtTabDataController:self willSelectedChanged:selectedIndex]){
                return;
            }
        }
        
        NSUInteger index = 0;
        
        for (UIButton * button in _tabButtons) {
            [button setEnabled:index != selectedIndex];
            index ++;
        }
        
        index = 0;
        
        for (UIView * view in _contentViews) {
            [view setHidden:index != selectedIndex];
            index ++;
        }
        
        _selectedIndex = selectedIndex;
        
        if([delegate respondsToSelector:@selector(vtTabDataController:didSelectedChanged:)]){
            [delegate vtTabDataController:self didSelectedChanged:_selectedIndex];
        }
    }
}

-(IBAction) doTabAction:(id)sender{
    NSUInteger index = [_tabButtons indexOfObject:sender];
    if(index != NSNotFound){
        [self setSelectedIndex:index];
    }
}

-(void) setContext:(id<IVTUIContext>)context{
    [super setContext:context];
    
    for(id controller in _controllers){
        [controller setContext:context];
    }
}

-(void) setControllers:(NSArray *)controllers{
    if(_controllers != controllers){
        NSArray * v = [controllers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        [_controllers release];
        _controllers = [v retain];
    }
}

-(void) setContentViews:(NSArray *)contentViews{
    if(_contentViews != contentViews){
        NSArray * v = [contentViews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        [_contentViews release];
        _contentViews = [v retain];
    }
}

-(void) setTabButtons:(NSArray *)tabButtons{
    if(_tabButtons != tabButtons){
        
        NSArray * v = [tabButtons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger i = [obj1 tag] - [obj2 tag];
            if(i < 0){
                return NSOrderedAscending;
            }
            if(i > 0){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        [_tabButtons release];
        _tabButtons = [v retain];
    }
}

@end
