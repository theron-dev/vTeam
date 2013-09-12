//
//  VTMontageElement.m
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontageElement.h"

#import "VTMontageScenes.h"

@implementation VTMontageElement

@synthesize locusName = _locusName;
@synthesize afterDelay = _afterDelay;
@synthesize duration = _duration;
@synthesize nextElement = _nextElement;

-(void) dealloc{
    [_nextElement release];
    [_locusName release];
    [super dealloc];
}

-(void) scenes:(VTMontageScenes *) scehes onValueChanged:(float) value{
    
}

@end
