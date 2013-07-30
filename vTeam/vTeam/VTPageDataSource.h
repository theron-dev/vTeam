//
//  VTPageDataSource.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDataSource.h>

#import <vTeam/IVTDownlinkPageTask.h>

@interface VTPageDataSource : VTDataSource<IVTDownlinkPageTask>

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) BOOL hasMoreData;

-(void) loadMoreData;


@end
