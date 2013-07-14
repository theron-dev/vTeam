//
//  VTPageDataSource.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTPageDataSource.h"

@interface VTPageDataSource(){
    BOOL _hasMoreData;
}

@end

@implementation VTPageDataSource

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;


-(id) init{
    if((self = [super init])){
        _pageIndex = 1;
        _pageSize = 20;
    }
    return self;
}

-(NSInteger) vtDownlinkPageTaskPageIndex{
    return _pageIndex;
}

-(NSInteger) vtDownlinkPageTaskPageSize{
    return _pageSize;
}

-(void) loadMoreData{
    _pageIndex ++;
    self.loading = YES;
    if([self.delegate respondsToSelector:@selector(vtDataSourceWillLoading:)]){
        [self.delegate vtDataSourceWillLoading:self];
    }
}

-(void) reloadData{
    _pageIndex = 1;
    [super reloadData];
}

-(BOOL) hasMoreData{
    return _hasMoreData;
}

-(void) vtDownlinkTaskDidLoadedFromCache:(id)data timestamp:(NSDate *)timestamp forTaskType:(Protocol *)taskType{
    [super vtDownlinkTaskDidLoadedFromCache:data timestamp:timestamp forTaskType:taskType];
    _hasMoreData = YES;
}

-(void) vtDownlinkTaskDidLoaded:(id) data forTaskType:(Protocol *) taskType{
    
    NSInteger count = [[self dataObjects] count];
    
    self.loading = NO;
    
    if(_pageIndex == 1){
        [[self dataObjects] removeAllObjects];
        count = 0;
    }
    
    [self loadResultsData:data];
    
    _hasMoreData = [[self dataObjects] count] - count >0;
    
    if([self.delegate respondsToSelector:@selector(vtDataSourceDidLoaded:)]){
        [self.delegate vtDataSourceDidLoaded:self];
    }
    
    self.loaded = YES;
}


@end
