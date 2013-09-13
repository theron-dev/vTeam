//
//  VTMontageGroupElement.m
//  vTeam
//
//  Created by zhang hailong on 13-9-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontageGroupElement.h"

@implementation VTMontageGroupElement

@synthesize elements = _elements;

-(void) dealloc{
    [_elements release];
    [super dealloc];
}

-(void) setElements:(NSArray *)elements{
    if(_elements != elements){
        [elements retain];
        [_elements release];
        _elements = elements;
        
        NSTimeInterval duration = 0;
        NSTimeInterval dur = 0;
        
        for (VTMontageElement * el in _elements) {
            
            dur = 0;
            
            while(el){
                dur += el.afterDelay + el.duration;
                el = [el nextElement];
            }
            
            if(dur > duration){
                duration = dur;
            }
        }
        
        [self setDuration:duration];
    }
}

-(void) scenes:(VTMontageScenes *) scehes onValueChanged:(float) value{
    
    NSTimeInterval current = value * self.duration;
    
    for(VTMontageElement * el in _elements){
        
        NSTimeInterval duration = 0.0;
        
        while(el){
            
            [el scenes:scehes onValueChanged:(current - duration - el.afterDelay) / el.duration];
            
            duration += el.duration + el.afterDelay;
            
            el = [el nextElement];
        }
        
    }
    
}

@end
