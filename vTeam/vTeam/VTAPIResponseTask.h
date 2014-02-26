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
@property(nonatomic,retain) NSURL * url;
@property(nonatomic,assign) NSInteger statusCode;
@property(nonatomic,retain) NSString * responseUUID;

@end

@interface VTAPIResponseTask : VTAPITask<IVTAPIResponseTask>

@end
