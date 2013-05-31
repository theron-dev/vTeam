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
@synthesize context = _context;
@synthesize delegate = _delegate;

-(void) dealloc{
    [self.context cancelHandleForSource:self];
    [_dataSource setDelegate:nil];
    [_dataSource release];
    [super dealloc];
}

-(void) reloadData{
    [_dataSource reloadData];
}

-(void) cancel{
    [_dataSource cancel];
}

-(void) setContext:(id<IVTUIContext>)context{
    _context = context;
    [_dataSource setContext:context];
}

-(void) vtDataSourceWillLoading:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){
        if([_delegate respondsToSelector:@selector(vtDataControllerWillLoading:)]){
            [_delegate vtDataControllerWillLoading:self];
        }
    }
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    if(dataSource == _dataSource){
        if([_delegate respondsToSelector:@selector(vtDataControllerDidLoadedFromCache:timestamp:)]){
            [_delegate vtDataControllerDidLoadedFromCache:self timestamp:timestamp];
        }
    }
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){
        if([_delegate respondsToSelector:@selector(vtDataControllerDidLoaded:)]){
            [_delegate vtDataControllerDidLoaded:self];
        }
    }
}

-(void) vtDataSource:(VTDataSource *) dataSource didFitalError:(NSError *) error{
    if(dataSource == _dataSource){
        if([_delegate respondsToSelector:@selector(vtDataController:didFitalError:)]){
            [_delegate vtDataController:self didFitalError:error];
        }
    }
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    if(dataSource == _dataSource){

    }
}

-(void) downloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView httpTask] == nil && ![imageView isLoaded]){
            [imageView setSource:self];
            [self.context handle:@protocol(IVTImageTask) task:imageView priority:0];
        }
    }
}

-(void) loadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView httpTask]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
        if(![imageView isLoaded]){
            [self.context handle:@protocol(IVTLocalImageTask) task:imageView priority:0];
        }
    }
}

-(void) cancelDownloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView httpTask]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
    }
}


@end
