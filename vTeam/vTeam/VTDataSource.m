//
//  VTDataSource.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDataSource.h"

#import "VTDataOutlet.h"

@interface VTDataSource(){

}

@end

@implementation VTDataSource

@synthesize context = _context;
@synthesize dataObjects = _dataObjects;
@synthesize delegate = _delegate;
@synthesize loading = _loading;
@synthesize loaded = _loaded;
@synthesize dataKey = _dataKey;

-(void) dealloc{
    [self cancel];
    [self.context cancelHandleForSource:self];
    [_dataObjects release];
    [super dealloc];
}
-(BOOL) isEmpty{
    return [_dataObjects count] == 0;
}

-(void) reloadData{
    _loading = YES;
    if([_delegate respondsToSelector:@selector(vtDataSourceWillLoading:)]){
        [_delegate vtDataSourceWillLoading:self];
    }
}

-(void) cancel{
    _loading = NO;
}

-(NSInteger) count{
    return [_dataObjects count];
}

-(NSMutableArray *) dataObjects{
    if(_dataObjects == nil){
        _dataObjects = [[NSMutableArray alloc] init];
    }
    return _dataObjects;
}

-(id) dataObjectAtIndex:(NSInteger) index{
    if(index>=0 && index < [_dataObjects count]){
        return [_dataObjects objectAtIndex:index];
    }
    return nil;
}


-(id) dataObject{
    if([_dataObjects count ]>0){
        return [_dataObjects objectAtIndex:0];
    }
    return nil;
}

-(void) loadResultsData:(id) resultsData{
    
    NSArray * items = _dataKey ? [resultsData dataForKeyPath:_dataKey] : resultsData;
    
    if([items isKindOfClass:[NSArray class]]){
        [[self dataObjects] addObjectsFromArray:items];
    }
    else if(items){
        [[self dataObjects] addObject:items];
    }
}

-(void) vtDownlinkTaskDidLoadedFromCache:(id) data timestamp:(NSDate *) timestamp forTaskType:(Protocol *) taskType{

    [[self dataObjects] removeAllObjects];
    
    [self loadResultsData:data];
    
    if([_delegate respondsToSelector:@selector(vtDataSourceDidLoadedFromCache:timestamp:)]){
        [_delegate vtDataSourceDidLoadedFromCache:self timestamp:timestamp];
    }
}

-(void) vtDownlinkTaskDidLoaded:(id) data forTaskType:(Protocol *) taskType{
    _loading = NO;
    [[self dataObjects] removeAllObjects];
    
    [self loadResultsData:data];
    
    if([_delegate respondsToSelector:@selector(vtDataSourceDidLoaded:)]){
        [_delegate vtDataSourceDidLoaded:self];
    }
    _loaded = YES;
}

-(void) vtDownlinkTaskDidFitalError:(NSError *) error forTaskType:(Protocol *) taskType{
    _loading = NO;
    if([_delegate respondsToSelector:@selector(vtDataSource:didFitalError:)]){
        [_delegate vtDataSource:self didFitalError:error];
    }
}

@end
