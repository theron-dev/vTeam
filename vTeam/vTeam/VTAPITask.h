//
//  VTAPITask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>
#import <vTeam/IVTAPITask.h>
#import <vTeam/IVTAPICancelTask.h>

@interface VTAPITask : VTTask<IVTAPITask,IVTAPICancelTask>

@end
