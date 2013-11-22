//
//  VTDataSource.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>
#import <vTeam/IVTDownlinkTask.h>
#import <vTeam/IVTServiceContext.h>
#import <vTeam/IVTController.h>
#import <vTeam/IVTUIContext.h>

@interface VTDataSource : VTTask<IVTDownlinkTask,IVTController>

@property(nonatomic,assign,getter = isLoading) BOOL loading;
@property(nonatomic,assign,getter = isLoaded) BOOL loaded;
@property(nonatomic,readonly,getter = isEmpty) BOOL empty;
@property(nonatomic,retain) NSString * dataKey;
@property(nonatomic,retain) NSMutableArray * dataObjects;

-(void) refreshData;

-(void) reloadData;

-(void) cancel;

-(NSInteger) count;

-(id) dataObjectAtIndex:(NSInteger) index;

-(void) loadResultsData:(id) resultsData;

-(id) dataObject;

@end

@protocol VTDataSourceDelegate 

@optional

-(void) vtDataSourceWillLoading:(VTDataSource *) dataSource;

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp;

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource;

-(void) vtDataSource:(VTDataSource *) dataSource didFitalError:(NSError *) error;

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource;

@end
