//
//  IVTServiceContainer.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTService.h>

@protocol IVTServiceContainer

@property(nonatomic,readonly) id instance;
@property(nonatomic,retain) id config;
@property(nonatomic,assign) id<IVTServiceContext> context;
@property(nonatomic,assign,getter=isInherit) BOOL inherit;

-(BOOL) hasTaskType:(Protocol *) taskType;

-(void) addTaskType:(Protocol *) taskType;

-(void) didReceiveMemoryWarning;

@end
