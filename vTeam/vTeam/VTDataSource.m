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
@synthesize skipCached = _skipCached;
@synthesize dataChanged = _dataChanged;

-(id) init{
    if((self = [super init])){
        _dataChanged = YES;
    }
    return self;
}

-(void) dealloc{
    [self cancel];
    [self.context cancelHandleForSource:self];
    [_dataObjects release];
    [super dealloc];
}

-(BOOL) isEmpty{
    return [_dataObjects count] == 0;
}

-(void) refreshData{
    [self reloadData];
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
    return [self.dataObjects count];
}

-(NSMutableArray *) dataObjects{
    if(_dataObjects == nil){
        _dataObjects = [[NSMutableArray alloc] init];
    }
    return _dataObjects;
}

-(id) dataObjectAtIndex:(NSInteger) index{
    if(index>=0 && index < [self.dataObjects count]){
        return [self.dataObjects objectAtIndex:index];
    }
    return nil;
}


-(id) dataObject{
    if([self.dataObjects count ]>0){
        return [self.dataObjects objectAtIndex:0];
    }
    return nil;
}

-(void) loadResultsData:(id) resultsData{
    
    NSArray * items = _dataKey ? [resultsData dataForKeyPath:_dataKey] : resultsData;
    
    if([items isKindOfClass:[NSArray class]]){
        [[self dataObjects] addObjectsFromArray:items];
    }
    else if([items isKindOfClass:[NSDictionary class]]){
        [[self dataObjects] addObject:items];
    }
}

-(void) vtDownlinkTaskDidLoadedFromCache:(id) data timestamp:(NSDate *) timestamp forTaskType:(Protocol *) taskType{

    if(_dataChanged){
        
        [[self dataObjects] removeAllObjects];
        [self loadResultsData:data];
        
        if([_delegate respondsToSelector:@selector(vtDataSourceDidLoadedFromCache:timestamp:)]){
            [_delegate vtDataSourceDidLoadedFromCache:self timestamp:timestamp];
        }
        
    }

    self.dataChanged = NO;
}

-(void) vtDownlinkTaskDidLoaded:(id) data forTaskType:(Protocol *) taskType{
    _loading = NO;
    
    if(self.dataChanged){
        
        [[self dataObjects] removeAllObjects];
    
        [self loadResultsData:data];
        
    }
    
    if([_delegate respondsToSelector:@selector(vtDataSourceDidLoaded:)]){
        [_delegate vtDataSourceDidLoaded:self];
    }
    _loaded = YES;
    _skipCached = NO;
    self.dataChanged = NO;
}

-(void) vtDownlinkTaskDidFitalError:(NSError *) error forTaskType:(Protocol *) taskType{
    _loading = NO;
    if([_delegate respondsToSelector:@selector(vtDataSource:didFitalError:)]){
        [_delegate vtDataSource:self didFitalError:error];
    }
    if([[self dataObjects] count]){
        _loaded = YES;
    }
    _skipCached = NO;
}

-(void) setContext:(id<IVTUIContext>)context{
    if(_context != context){
        [_context cancelHandleForSource:self];
        _context = context;
    }
}

@end
