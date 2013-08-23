//
//  VTBESessionObject.h
//  vTeam
//
//  Created by zhang hailong on 13-8-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTBehaviorObject.h>

@interface VTBESessionObject : VTBehaviorObject

@property(nonatomic,retain) NSString * session;
@property(nonatomic,assign) double startTimestamp;

+(NSString *) genSession;

@end
