//
//  VTMontageScenes.m
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontageScenes.h"

@interface VTMontageScenes(){

}

@end

@implementation VTMontageScenes

@synthesize startTimeInterval = _startTimeInterval;
@synthesize current = _current;
@synthesize duration = _duration;
@synthesize locuss = _locuss;
@synthesize contentView = _contentView;
@synthesize rootElement = _rootElement;
@synthesize repeatCount = repeatCount;
@synthesize repeatAutoreverses =_repeatAutoreverses;

-(void) dealloc{
    for (VTMontageLocus * locus in _locuss){
        [locus setScenes:nil];
    }
    [_locuss release];
    [_contentView release];
    [_rootElement release];
    [super dealloc];
}

-(void) didCurrentChanged{
    VTMontageElement * el = _rootElement;
    NSTimeInterval duration = 0.0;
    
    while(el){
        
        [el scenes:self onValueChanged:(_current - duration - el.afterDelay) / el.duration];
        
        duration += el.duration + el.afterDelay;
        
        el = [el nextElement];
    }
}

-(void) setCurrent:(NSTimeInterval)current{

    if(current > _duration){
        current = _duration;
    }
    
    if(current < 0){
        current = 0;
    }
    
    if(_current != current){
        _current = current;
        [self didCurrentChanged];
    }
}

-(VTMontageLocus *) locusForName:(NSString *) name{
    for(VTMontageLocus * locus in _locuss){
        if(locus.name == name || [locus.name isEqualToString:name]){
            [locus setScenes:self];
            return locus;
        }
    }
    return nil;
}

-(void) setRootElement:(VTMontageElement *)rootElement{
    if(_rootElement != rootElement){
        [rootElement retain];
        [_rootElement release];
        _rootElement = rootElement;
        _duration = 0.0;
        _current = 0.0;
        VTMontageElement * el = rootElement;
        while(el){
            _duration += el.duration + el.afterDelay;
            el = [el nextElement];
        }
        _current = 0.0;
        [self didCurrentChanged];
    }
}

-(NSTimeInterval) value{
    if(_duration == 0.0){
        return 0.0;
    }
    return _current / _duration;
}

-(void) setValue:(NSTimeInterval) value{
    [self setCurrent:value * _duration];
}



@end
