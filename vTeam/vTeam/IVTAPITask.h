//
//  IVTAPITask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTTask.h>

@protocol IVTAPITask <IVTTask>

@property(nonatomic,retain) id task;
@property(nonatomic,assign) Protocol * taskType;
@property(nonatomic,retain) id userInfo;

@end
