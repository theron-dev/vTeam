//
//  VTURLDocumentController.h
//  vTeam
//
//  Created by zhang hailong on 14-1-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <vTeam/VTController.h>
#import <vTeam/VTHttpTask.h>
#import <vTeam/VTDOMDocument.h>
#import <vTeam/VTDOMView.h>

#define VTURLDocumentControllerErrorCodeNotFoundDocumentURL     0x10
#define VTURLDocumentControllerErrorCodeNotSuppertDocumentURL   0x20
#define VTURLDocumentControllerErrorCodeNotFoundFileURL         0x30

@interface VTURLDocumentController : VTController<IVTHttpTaskDelegate,VTDOMViewDelegate>

@property(nonatomic,retain) IBOutlet VTDOMView * documentView;
@property(nonatomic,retain) NSURL * documentURL;
@property(nonatomic,retain) VTDOMDocument * document;
@property(nonatomic,readonly,getter = isLoading) BOOL loading;
@property(nonatomic,assign) NSTimeInterval timeoutInterval;
@property(nonatomic,readonly) NSString * documentFilePath;
@property(nonatomic,assign,getter = isAllowPreloadCached) BOOL allowPreloadCached;
@property(nonatomic,retain) NSString * documentUUID;

-(void) reloadData;

-(void) downloadImagesForElement:(VTDOMElement *) element;

-(void) downloadImagesForView:(UIView *) view;

-(void) reloadElement:(VTDOMElement *) element queryValues:(NSDictionary *) queryValues;

-(IBAction) doRefreshAction:(id)sender;

-(void) relayout;

@end

@protocol VTURLDocumentControllerDelegate

@optional

-(void) vtURLDocumentControllerWillLoading:(VTURLDocumentController *) controller;

-(void) vtURLDocumentController:(VTURLDocumentController *) controller doActionElement:(VTDOMElement *) element;

-(void) vtURLDocumentControllerDidLoaded:(VTURLDocumentController *) controller;

-(void) vtURLDocumentController:(VTURLDocumentController *) controller didFailWithError:(NSError *) error;

@end