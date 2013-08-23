//
//  VTBEEventObject.h
//  vTeam
//
//  Created by zhang hailong on 13-8-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTBehaviorObject.h>

@interface VTBEEventObject : VTBehaviorObject

@property(nonatomic,retain) NSString * session;
@property(nonatomic,retain) NSString * eventId;
@property(nonatomic,retain) NSString * tag;

@end
