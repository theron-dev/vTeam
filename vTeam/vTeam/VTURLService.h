//
//  VTURLService.h
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTURLService : VTDownlinkService<IVTHttpTaskDelegate>

-(NSError *) errorByResponseBody:(id) body task:(id) task;

@end
