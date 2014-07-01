//
//  VTDataController.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDataController.h"

#import "UIView+Search.h"
#import "IVTImageTask.h"

@implementation VTDataController

@synthesize dataSource = _dataSource;

-(void) dealloc{
    [self.context cancelHandleForSource:self];
    [_dataSource setDelegate:nil];
    [_dataSource cancel];
    [_dataSource release];
    [super dealloc];
}

-(void) reloadData{
    [_dataSource reloadData];
}

-(void) refreshData{
    [_dataSource refreshData];
}

-(void) cancel{
    [_dataSource cancel];
}

-(void) setContext:(id<IVTUIContext>)context{
    [super setContext:context];
    [_dataSource setContext:context];
}

-(void) vtDataSourceWillLoading:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){
        id delegate = self.delegate;
        if([delegate respondsToSelector:@selector(vtDataControllerWillLoading:)]){
            [delegate vtDataControllerWillLoading:self];
        }
    }
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
   
    if(dataSource == _dataSource){
        
        id delegate = self.delegate;
        
        if([delegate respondsToSelector:@selector(vtDataControllerDidLoadedFromCache:timestamp:)]){
            [delegate vtDataControllerDidLoadedFromCache:self timestamp:timestamp];
        }
    }
    
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){
        
        id delegate = self.delegate;
        
        if([delegate respondsToSelector:@selector(vtDataControllerDidLoaded:)]){
            [delegate vtDataControllerDidLoaded:self];
        }
    }
}

-(void) vtDataSource:(VTDataSource *) dataSource didFitalError:(NSError *) error{
    if(dataSource == _dataSource){
        
        id delegate = self.delegate;
        
        if([delegate respondsToSelector:@selector(vtDataController:didFitalError:)]){
            [delegate vtDataController:self didFitalError:error];
        }
    }
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){
        
        id delegate = self.delegate;
        
        if([delegate respondsToSelector:@selector(vtDataControllerDidContentChanged:)]){
            [delegate vtDataControllerDidContentChanged:self];
        }
    }
}

-(void) downloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if(![imageView isLoading] && ![imageView isLoaded]){
            [imageView setSource:self];
            [imageView setLocalAsyncLoad:YES];
            [self.context handle:@protocol(IVTImageTask) task:imageView priority:0];
        }
    }
}

-(void) loadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView isLoading]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
        if(![imageView isLoaded]){
            [imageView setLocalAsyncLoad:YES];
            [self.context handle:@protocol(IVTLocalImageTask) task:imageView priority:0];
        }
    }
}

-(void) cancelDownloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView isLoading]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
    }
}


@end
