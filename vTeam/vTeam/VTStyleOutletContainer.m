//
//  VTStyleContainer.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStyleOutletContainer.h>

@implementation VTStyleOutletContainer

@synthesize styles = _styles;
@synthesize status = _status;
@synthesize styleSheet = _styleSheet;

-(void) dealloc{
    
    [_styleSheet removeObserver:self forKeyPath:@"version"];
    
    [_styles release];
    [_status release];
    [_styleSheet release];
    [super dealloc];
}

-(void) applyStyleSheet {
    for(id style in _styles){
        if(_status == nil || [style status] == nil
           || [_status rangeOfString:[style status]].location != NSNotFound){
            [style setStyleSheet:_styleSheet];
        }
        else{
            [style setStyleSheet:nil];
        }
    }
}

-(void) setStyleSheet:(VTStyleSheet *) styleSheet{
    if(_styleSheet != styleSheet){
        
        [_styleSheet removeObserver:self forKeyPath:@"version"];
        [styleSheet addObserver:self forKeyPath:@"version" options:NSKeyValueObservingOptionNew context:nil];
        
        [styleSheet retain];
        [_styleSheet release];
        _styleSheet = styleSheet;
        
        [self applyStyleSheet];
    }
}

-(void) setStatus:(NSString *)status{
    if(_status != status){
        [status retain];
        [_status release];
        _status = status;
        [self applyStyleSheet];
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object == _styleSheet){
        if([keyPath isEqualToString:@"version"]){
            [self applyStyleSheet];
        }
    }
}

@end
