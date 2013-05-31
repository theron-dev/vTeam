//
//  VTAPIRequestTask.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTAPITask.h>
#import <vTeam/IVTAPITask.h>
#import <vTeam/VTHttpFormBody.h>
#import <vTeam/VTHttpTask.h>

@protocol IVTAPIRequestTask <IVTAPITask>

@property(nonatomic,retain) NSString * apiKey;
@property(nonatomic,retain) NSString * apiUrl;
@property(nonatomic,retain) NSDictionary * queryValues;
@property(nonatomic,retain) VTHttpFormBody * body;
@property(nonatomic,retain) VTHttpTask * httpTask;

@end

@interface VTAPIRequestTask : VTAPITask<IVTAPITask,IVTAPIRequestTask>



@end
