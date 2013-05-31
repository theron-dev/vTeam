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

-(void) dealloc{
    [_styleSheet removeObserver:self forKeyPath:@"version"];
    [_views release];
    [_styleName release];
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
    [_styleSheet removeObserver:self forKeyPath:@"version"];
    [styleSheet addObserver:self forKeyPath:@"version" options:NSKeyValueObservingOptionNew context:nil];
    _styleSheet = styleSheet;
    [self applyStyle];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(object == _styleSheet){
        if([keyPath isEqualToString:@"version"]){
            [self applyStyle];
        }
    }
}

@end
