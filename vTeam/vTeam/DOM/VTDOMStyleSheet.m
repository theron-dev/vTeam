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

@synthesize version = _version;
@synthesize styles = _styles;

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
        
        for(VTDOMStyle * s in _styles){
            
            if([name isEqualToString:s.name]){
                
                for(NSString * key in s.allKeys){
                    [style setStringValue:[s stringValueForKey:key] forKey:key];
                }
                
            }
            
        }
        
    }
    
    return [style autorelease];
}

@end
