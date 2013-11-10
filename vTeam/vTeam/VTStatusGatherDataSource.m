//
//  VTStatusGatherDataSource.m
//  vTeam
//
//  Created by zhang hailong on 13-11-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTStatusGatherDataSource.h"

@implementation VTStatusGatherDataSource

-(void) dealloc{
    for (VTStatusDataSource * dataSource in _dataSources) {
        [dataSource setContext:nil];
        [dataSource setDelegate:nil];
    }
    [_dataSources release];
    _dataSources = nil;
    [super dealloc];
}

-(BOOL) isLoading{
    return [[self dataSource] isLoading];
}
    
-(BOOL) isLoaded{
    return [[self dataSource] isLoaded];
}

-(BOOL) isEmpty{
    return [[self dataSource] isEmpty];
}
    
-(void) refreshData{
    [[self dataSource] refreshData];
}

-(void) reloadData{
    [[self dataSource] reloadData];
}
    
-(void) cancel{
    [[self dataSource] cancel];
}
    
-(BOOL) hasMoreData{
    return [[self dataSource] hasMoreData];
}
    
-(void) loadMoreData{
    [[self dataSource] loadMoreData];
}
    
-(void) setPageSize:(NSInteger)pageSize{
    [super setPageSize:pageSize];
    [[self dataSource] setPageSize:pageSize];
}
    
-(void) setPageIndex:(NSInteger)pageIndex{
    [super setPageIndex:pageIndex];
    [[self dataSource] setPageIndex:pageIndex];
}
    
-(NSMutableArray *) dataObjects{
    return [[self dataSource] dataObjects];
}
    
-(void) vtDataSourceWillLoading:(VTDataSource *) dataSource{
    if(dataSource == [self dataSource]){
        if([self.delegate respondsToSelector:@selector(vtDataSourceWillLoading:)]){
            [self.delegate vtDataSourceWillLoading:self];
        }
    }
}
    
-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    if(dataSource == [self dataSource]){
        if([self.delegate respondsToSelector:@selector(vtDataSourceDidLoadedFromCache:timestamp:)]){
            [self.delegate vtDataSourceDidLoadedFromCache:self timestamp:timestamp];
        }
    }
}
    
-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    if(dataSource == [self dataSource]){
        if([self.delegate respondsToSelector:@selector(vtDataSourceDidLoaded:)]){
            [self.delegate vtDataSourceDidLoaded:self];
        }
    }
}
    
-(void) vtDataSource:(VTDataSource *) dataSource didFitalError:(NSError *) error{
    if(dataSource == [self dataSource]){
        if([self.delegate respondsToSelector:@selector(vtDataSource:didFitalError:)]){
            [self.delegate vtDataSource:self didFitalError:error];
        }
    }
}
    
-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    if(dataSource == [self dataSource]){
        if([self.delegate respondsToSelector:@selector(vtDataSourceDidContentChanged:)]){
            [self.delegate vtDataSourceDidContentChanged:self];
        }
    }
}
  
-(VTStatusDataSource *) dataSource{
    
    for (VTStatusDataSource * dataSource in _dataSources) {
        if([self.status isEqualToString:dataSource.status]){
            return dataSource;
        }
    }
    
    return [_dataSources count] > 0 ? [_dataSources objectAtIndex:0] : nil;
}

-(void) setContext:(id<IVTUIContext>)context{
    [super setContext:context];
    for (VTStatusDataSource * dataSource in _dataSources) {
        [dataSource setContext:context];
    }
}

@end
