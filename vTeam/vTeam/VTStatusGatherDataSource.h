//
//  VTStatusGatherDataSource.h
//  vTeam
//
//  Created by zhang hailong on 13-11-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStatusDataSource.h>

@interface VTStatusGatherDataSource : VTStatusDataSource<VTDataSourceDelegate>

@property(nonatomic,retain) IBOutletCollection(VTStatusDataSource) NSArray * dataSources;
@property(nonatomic,readonly) VTStatusDataSource * dataSource;
    
@end
