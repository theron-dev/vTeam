//
//  VTStyleOutlet.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStyleOutlet.h>

#import <vTeam/VTStyleSheet.h>

@implementation VTStyleOutlet

@synthesize styleName = _styleName;
@synthesize views = _views;
@synthesize styleSheet = _styleSheet;
@synthesize version = _version;
@synthesize status = _status;

-(void) dealloc{
    [_views release];
    [_styleName release];
    [_status release];
    [super dealloc];
}


-(void) applyStyle{
    
    NSDictionary * style = [_styleSheet selectorStyle:self.styleName];
    
    for(UIView * v in _views){
        for(NSString * key in style){
            @try {
                VTStyle * s = [style objectForKey:key];
                if(s.imageValue){
                    [v setValue:[_styleSheet styleValueImage:s.imageValue] forKey:key];
                }
                else if(s.fontValue){
                    [v setValue:[_styleSheet styleValueFont:s.fontValue] forKey:key];
                }
                else if(s.edgeValue){
                    [v setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(s.edgeValue)] forKey:key];
                }
                else if(s.value){
                    [v setValue:s.value forKey:key];
                }
            }
            @catch (NSException *exception) {
                
            }
        }
    }
    
    _version = [_styleSheet version];
}

-(void) setStyleSheet:(VTStyleSheet *)styleSheet{
    _styleSheet = styleSheet;
    [self applyStyle];
}

-(void) setStyleName:(NSString *)styleName{
    if(_styleName != styleName){
        [styleName retain];
        [_styleName release];
        _styleName = styleName;
        if(_styleSheet){
            [self applyStyle];
        }
    }
}

@end
