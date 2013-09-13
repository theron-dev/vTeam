//
//  VTMontageViewElement.m
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontageViewElement.h"

#import "VTMontageScenes.h"

@implementation VTMontageViewElement

@synthesize view = _view;

-(void) dealloc{
    [_view release];
    [super dealloc];
}

-(void) scenes:(VTMontageScenes *) scehes onValueChanged:(float) value{
    
    VTMontageLocusPoint p = [[scehes locusForName:self.locusName] locusPoint:value element:self];
    
    UIView * contentView = [scehes contentView];
    
    if([contentView isKindOfClass:[UIView class]]){
        
        CGSize size = contentView.bounds.size;
 
        CGRect r = _view.frame;
        
        _view.center = CGPointMake(size.width * p.x , (size.height -  r.size.height) * (1.0 - p.y) + r.size.height / 2.0);
 
        if(_view.superview != contentView){
            [contentView addSubview:_view];
        }
    }
    
}

@end
