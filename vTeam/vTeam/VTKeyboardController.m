//
//  VTKeyboardController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTKeyboardController.h"

@implementation VTKeyboardController

@synthesize delegate = _delegate;

-(id) init{
    if((self = [super init])){
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardDidShowAction:) name:UIKeyboardDidShowNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(keyboardDidHideAction:) name:UIKeyboardDidHideNotification object:nil];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0){
            [notificationCenter addObserver:self selector:@selector(keyboardWillChangedAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
            [notificationCenter addObserver:self selector:@selector(keyboardDidChangedAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
        }
    }
    return self;
}

-(void) dealloc{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0){
        [notificationCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [notificationCenter removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    [super dealloc];
}

-(CGRect) rectForNotification:(NSNotification *) notification{
    return [[notification.userInfo valueForKey: UIKeyboardFrameEndUserInfoKey ] CGRectValue];
}

-(void) keyboardWillShowAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:willShowFrame:)]){
        [_delegate vtKeyboardController:self willShowFrame:[self rectForNotification:notification]];
    }
}

-(void) keyboardDidShowAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:didShowFrame:)]){
        [_delegate vtKeyboardController:self didShowFrame:[self rectForNotification:notification]];
    }
}

-(void) keyboardWillHideAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:willHideFrame:)]){
        [_delegate vtKeyboardController:self willHideFrame:[self rectForNotification:notification]];
    }
}

-(void) keyboardDidHideAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:didHideFrame:)]){
        [_delegate vtKeyboardController:self didHideFrame:[self rectForNotification:notification]];
    }
}

-(void) keyboardWillChangedAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:willChangedFrame:)]){
        [_delegate vtKeyboardController:self willChangedFrame:[self rectForNotification:notification]];
    }
}

-(void) keyboardDidChangedAction:(NSNotification *) notification{
    if([(id)_delegate respondsToSelector:@selector(vtKeyboardController:didChangedFrame:)]){
        [_delegate vtKeyboardController:self didChangedFrame:[self rectForNotification:notification]];
    }
}


@end
