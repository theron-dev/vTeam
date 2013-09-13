//
//  VTMontageElement.h
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VTMontageScenes;

@interface VTMontageElement : NSObject

@property(nonatomic,retain) NSString * locusName;
@property(nonatomic,assign) NSTimeInterval afterDelay;
@property(nonatomic,assign) NSTimeInterval duration;
@property(nonatomic,retain) IBOutlet VTMontageElement * nextElement;

-(void) scenes:(VTMontageScenes *) scehes onValueChanged:(float) value;

@end
