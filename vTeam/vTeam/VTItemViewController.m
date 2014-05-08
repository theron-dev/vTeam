//
//  VTItemViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTItemViewController.h"

#import "IVTImageTask.h"

#import "UIView+Search.h"

@interface VTItemViewController ()

@end

@implementation VTItemViewController

@synthesize context = _context;
@synthesize styleContainer = _styleContainer;
@synthesize dataOutletContainer = _dataOutletContainer;

@synthesize index = _index;
@synthesize userInfo = _userInfo;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize delegate = _delegate;
@synthesize dataItem = _dataItem;
@synthesize layoutContainer = _layoutContainer;
@synthesize dataSource = _dataSource;
@synthesize itemSize = _itemSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_styleContainer setStyleSheet:[self.context styleSheet]];
    [_layoutContainer layout];
}

-(void) viewDidUnload{
    [self setStyleContainer:nil];
    [self setDataOutletContainer:nil];
    [super viewDidUnload];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_dataItem release];
    [_userInfo release];
    [_reuseIdentifier release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [_dataSource setDelegate:nil];
    [_dataSource release];
    [super dealloc];
}

-(IBAction) doAction :(id)sender{
    if([sender conformsToProtocol:@protocol(IVTAction)]){
        if([_delegate respondsToSelector:@selector(vtItemViewController:doAction:)]){
            [_delegate vtItemViewController:self doAction:sender];
        }
    }
}

-(void) setDataItem:(id)dataItem{
    if(_dataItem != dataItem){
        [_dataItem release];
        _dataItem = [dataItem retain];
        [self view];
        [_dataOutletContainer applyDataOutlet:self];
        [self loadImagesForView:self.view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self downloadImagesForView:self.view];
            
        });
        
        [_layoutContainer layout];
        [_dataSource cancel];
        [_dataSource reloadData];
    }
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_layoutContainer layout];
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self.view];
    [_layoutContainer layout];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self.view];
    [_layoutContainer layout];
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    [_dataOutletContainer applyDataOutlet:self];
    [self downloadImagesForView:self.view];
    [_layoutContainer layout];
}

-(void) downloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if(![imageView isLoading] && ![imageView isLoaded]){
            [imageView setSource:self];
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

-(void) setContext:(id<IVTUIContext>)context{
    if(_context != context){
        _context = context;
        [_dataSource setContext:context];
    }
}

@end
