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

@protocol IVTAPIWillRequestTask <IVTAPITask>

@property(nonatomic,retain) NSString * apiKey;
@property(nonatomic,retain) NSString * apiUrl;
@property(nonatomic,retain) NSDictionary * queryValues;
@property(nonatomic,retain) VTHttpFormBody * body;
@property(nonatomic,retain) NSString * httpMethod;
@property(nonatomic,retain) NSDictionary * httpHeaders;

@end

@protocol IVTAPIRequestTask <IVTAPIWillRequestTask>

@end

@interface VTAPIRequestTask : VTAPITask<IVTAPITask,IVTAPIRequestTask>



@end
