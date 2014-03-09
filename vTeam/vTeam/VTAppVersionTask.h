//
//  VTAppVersionTask.h
//  vTeam
//
//  Created by zhang hailong on 14-3-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTUplinkTask.h>

typedef enum _VTAppVersionTaskLevel{
    VTAppVersionTaskLevelNone = 0,VTAppVersionTaskLevelSuggest = 1,VTAppVersionTaskLevelForce = 2
} VTAppVersionTaskLevel;

@protocol IVTAppVersionTask <IVTUplinkTask>

@property(nonatomic,assign) VTAppVersionTaskLevel level;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * uri;
@property(nonatomic,retain) NSString * version;


@end

@interface VTAppVersionTask : VTUplinkTask<IVTAppVersionTask>

@end
