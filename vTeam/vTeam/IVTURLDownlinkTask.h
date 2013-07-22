//
//  IVTURLDownlinkTask.h
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTDownlinkPageTask.h>

@protocol IVTURLDownlinkTask <IVTDownlinkPageTask>

@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * urlKey;

@property(nonatomic,retain) NSString * errorCodeKeyPath;
@property(nonatomic,retain) NSString * errorKeyPath;
@property(nonatomic,assign) Class httpClass;

@property(nonatomic,retain) id queryValues;

@end
