//
//  VTDOMStyleSheet.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMStyleSheet.h"

@interface VTDOMStyleSheet(){
    NSMutableArray * _styles;
}

@end

@implementation VTDOMStyleSheet

-(void) dealloc{
    [_styles release];
    [super dealloc];
}

-(void) addStyle:(VTDOMStyle *) style{
    if(_styles == nil){
        _styles = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_styles addObject:style];
}

-(void) removeStyle:(VTDOMStyle *) style{
    [_styles removeObject:style];
}

-(void) removeAllStyles{
    [_styles removeAllObjects];
}

-(VTDOMStyle *) selectorStyleName:(NSString *) styleName{
    
    NSArray * names = [styleName componentsSeparatedByString:@" "];
    
    VTDOMStyle * style = [[VTDOMStyle alloc] init];
    
    for(NSString * name in names){
        
        for(VTDOMStyle * style in _styles){
            
            if([name isEqualToString:style.name]){
                
                for(NSString * key in style.allKeys){
                    [style setStringValue:[style stringValueForKey:key] forKey:key];
                }
                
            }
            
        }
        
    }
    
    return [style autorelease];
}

@end
