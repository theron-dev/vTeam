//
//  VTTableViewCell.m
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableViewCell.h"

#import "IVTImageTask.h"

#import "UIView+Search.h"


@implementation VTTableViewCell

@synthesize nibNameOrNil = _nibNameOrNil;
@synthesize nibBundleOrNil = _nibBundleOrNil;

@synthesize context = _context;
@synthesize styleContainer = _styleContainer;
@synthesize dataOutletContainer = _dataOutletContainer;

@synthesize index = _index;
@synthesize userInfo = _userInfo;
@synthesize delegate = _delegate;
@synthesize dataItem = _dataItem;
@synthesize layoutContainer = _layoutContainer;
@synthesize dataSource = _dataSource;
@synthesize controller = _controller;

-(void) dealloc{
    [_dataItem release];
    [_userInfo release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [_dataSource setDelegate:nil];
    [_dataSource release];
    [_nibNameOrNil release];
    [_nibBundleOrNil release];
    [super dealloc];
}

+(id) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    UIViewController * viewController = [[[UIViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil] autorelease];
    
    UIView * view = [viewController view];
    
    if([view isKindOfClass:[VTTableViewCell class]]){
        return view;
    }
    
    return nil;
}


-(IBAction) doAction :(id)sender{
    if([sender conformsToProtocol:@protocol(IVTAction)]){
        if([_delegate respondsToSelector:@selector(vtTableViewCell:doAction:)]){
            [_delegate vtTableViewCell:self doAction:sender];
        }
    }
}

-(void) setDataItem:(id)dataItem{
    if(_dataItem != dataItem){
        [_dataItem release];
        _dataItem = [dataItem retain];
        [_dataOutletContainer applyDataOutlet:self];
        [self cancelDownloadImagesForView:self];
        [self loadImagesForView:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadImagesForView:) object:nil];
        [self performSelector:@selector(downloadImagesForView:) withObject:self afterDelay:0.0];
        [_layoutContainer layout];
        [_dataSource cancel];
        [_dataSource reloadData];
    }
    else{
        [_dataOutletContainer applyDataOutlet:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadImagesForView:) object:nil];
        [self performSelector:@selector(downloadImagesForView:) withObject:self afterDelay:0.0];
        [_layoutContainer layout];
    }
}


-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self];
    [_layoutContainer layout];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self];
    [_layoutContainer layout];
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self];
    [_layoutContainer layout];
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

-(void) setContext:(id<IVTUIContext>)context{
    if(_context != context){
        _context = context;
        [_dataSource setContext:context];
        [_styleContainer setStyleSheet:[context styleSheet]];
        [_layoutContainer layout];
    }
}


@end
