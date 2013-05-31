//
//  VTAPIResponseTask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTAPITask.h>


@protocol IVTAPIResponseTask <IVTAPITask>

@property(nonatomic,retain) id resultsData;
@property(nonatomic,retain) NSError * error;

@end

@interface VTAPIResponseTask : VTAPITask<IVTAPIResponseTask>

@end
