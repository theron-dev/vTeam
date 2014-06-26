//
//  VTPageDataSource.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTPageDataSource.h"

@interface VTPageDataSource(){
}

@end

@implementation VTPageDataSource

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize hasMoreData = _hasMoreData;

-(id) init{
    if((self = [super init])){
        self.pageIndex = 1;
        self.pageSize = 20;
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
    self.pageIndex ++;
    self.loading = YES;
    if([self.delegate respondsToSelector:@selector(vtDataSourceWillLoading:)]){
        [self.delegate vtDataSourceWillLoading:self];
    }
}


-(void) reloadData{
    
    if(self.pageIndex !=1){
        self.pageIndex = 1;
        self.dataChanged = YES;
    }

    [super reloadData];
}

-(BOOL) hasMoreData{
    return _hasMoreData;
}

-(void) loadResultsData:(id)resultsData{
    
    NSUInteger c = [self count];
    
    [super loadResultsData:resultsData];
    
    self.hasMoreData = [self count] != c;
    
}

-(void) vtDownlinkTaskDidLoaded:(id) data forTaskType:(Protocol *) taskType{
    
    self.loading = NO;
    
    if(self.dataChanged){
        
        if(_pageIndex == 1){
            [[self dataObjects] removeAllObjects];
        }
        
        [self loadResultsData:data];
    }

    if([self.delegate respondsToSelector:@selector(vtDataSourceDidLoaded:)]){
        [self.delegate vtDataSourceDidLoaded:self];
    }
    
    self.loaded = YES;
    self.dataChanged = NO;
}


@end
