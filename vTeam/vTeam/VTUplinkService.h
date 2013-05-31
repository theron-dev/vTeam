//
//  VTUplinkService.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTService.h>

#import <vTeam/IVTUplinkTask.h>

@interface VTUplinkService : VTService

-(void) vtUplinkTask:(id<IVTUplinkTask>) uplinkTask didSuccessResults:(id) data forTaskType:(Protocol *) taskType;

-(void) vtUplinkTask:(id<IVTUplinkTask>) uplinkTask didFailWithError:(NSError *) error forTaskType:(Protocol *) taskType;


@end
