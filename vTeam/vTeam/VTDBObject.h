//
//  VTDBObject.h
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTDBObject : NSObject

@property(nonatomic,assign) long long rowid;

+(Class) tableClass;

@end
