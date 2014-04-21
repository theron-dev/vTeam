//
//  VTDataController.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTUIContext.h>
#import <vTeam/VTDataSource.h>
#import <vTeam/VTController.h>

@interface VTDataController : VTController<VTDataSourceDelegate,IVTController>

@property(nonatomic,retain) IBOutlet VTDataSource * dataSource;

-(void) refreshData;

-(void) reloadData;

-(void) cancel;

-(void) downloadImagesForView:(UIView *) view;

-(void) loadImagesForView:(UIView *) view;

-(void) cancelDownloadImagesForView:(UIView *) view;

@end

@protocol VTDataControllerDelegate

@optional

-(void) vtDataControllerWillLoading:(VTDataController *) controller;

-(void) vtDataControllerDidLoadedFromCache:(VTDataController *) controller timestamp:(NSDate *) timestamp;

-(void) vtDataControllerDidLoaded:(VTDataController *) controller;

-(void) vtDataController:(VTDataController *) controller didFitalError:(NSError *) error;

-(void) vtDataControllerDidContentChanged:(VTDataController *) controller;

@end
