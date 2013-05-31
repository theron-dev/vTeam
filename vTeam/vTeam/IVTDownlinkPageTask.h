//
//  IVTDownlinkPageTask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTDownlinkTask.h>

@protocol IVTDownlinkPageTask <IVTDownlinkTask>

-(NSInteger) vtDownlinkPageTaskPageSize;

-(NSInteger) vtDownlinkPageTaskPageIndex;

@end
