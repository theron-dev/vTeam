//
//  VTMontageLocus.h
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _VTMontageLocusPoint {
    float x;
    float y;
    float z;
} VTMontageLocusPoint;

@class VTMontageElement;

@class VTMontageScenes;

@interface VTMontageLocus : NSObject

@property(nonatomic,retain) NSString * name;
@property(nonatomic,assign) VTMontageScenes * scenes;

-(VTMontageLocusPoint) locusPoint:(float) value element:(VTMontageElement *) element;

@end
