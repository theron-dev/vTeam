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

@interface VTDataSource : VTTask<IVTDownlinkTask>

@property(nonatomic,unsafe_unretained) id<IVTServiceContext> context;
@property(nonatomic,unsafe_unretained) IBOutlet id delegate;
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

-(id) dataObject;

-(void) loadResultsData:(id) resultsData;

@end

@protocol VTDataSourceDelegate 

@optional

-(void) vtDataSourceWillLoading:(VTDataSource *) dataSource;

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp;

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource;

-(void) vtDataSource:(VTDataSource *) dataSource didFitalError:(NSError *) error;

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource;

@end
