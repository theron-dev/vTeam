//
//  VTMontageLocus.m
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTMontageLocus.h"

@implementation VTMontageLocus

@synthesize scenes = _scenes;
@synthesize name = _name;

-(void) dealloc{
    [_name release];
    [super dealloc];
}

-(VTMontageLocusPoint) locusPoint:(float) value element:(VTMontageElement *) element{
    VTMontageLocusPoint p = {value,value,value};
    return p;
}

@end
