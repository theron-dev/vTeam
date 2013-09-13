//
//  VTMontageScenes.h
//  vTeam
//
//  Created by zhang hailong on 13-9-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTMontageLocus.h>
#import <vTeam/VTMontageElement.h>

@interface VTMontageScenes : NSObject

@property(nonatomic,assign) NSTimeInterval startTimeInterval;
@property(nonatomic,assign) NSUInteger repeatCount;
@property(nonatomic,assign,getter = isRepeatAutoreverses) BOOL repeatAutoreverses;
@property(nonatomic,retain) IBOutlet id contentView;
@property(nonatomic,assign) NSTimeInterval current;
@property(nonatomic,assign) NSTimeInterval duration;
@property(nonatomic,retain) IBOutletCollection(VTMontageLocus) NSArray * locuss;
@property(nonatomic,retain) IBOutlet VTMontageElement * rootElement;
@property(nonatomic,assign) NSTimeInterval value;

-(VTMontageLocus *) locusForName:(NSString *) name;

@end

