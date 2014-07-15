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
#define VTURLDocumentControllerErrorCodeNotSupperDocumentVersion         0x40

@interface VTURLDocumentController : VTController<IVTHttpTaskDelegate,VTDOMViewDelegate>

@property(nonatomic,retain) IBOutlet VTDOMView * documentView;
@property(nonatomic,retain) NSURL * documentURL;
@property(nonatomic,retain) VTDOMDocument * document;
@property(nonatomic,readonly,getter = isLoading) BOOL loading;
@property(nonatomic,assign) NSTimeInterval timeoutInterval;
@property(nonatomic,readonly) NSString * documentFilePath;
@property(nonatomic,assign,getter = isAllowPreloadCached) BOOL allowPreloadCached;
@property(nonatomic,retain) NSString * documentUUID;
@property(nonatomic,retain) NSString * errorDocument;

-(void) reloadData;

-(void) downloadImagesForElement:(VTDOMElement *) element;

-(void) downloadImagesForView:(UIView *) view;

-(void) reloadElement:(VTDOMElement *) element queryValues:(NSDictionary *) queryValues;

-(IBAction) doRefreshAction:(id)sender;

-(void) relayout;

-(void) documentWillLoad;

-(void) documentDidLoad;

-(void) cancel;

-(void) documentLayout;

-(void) documentWillLayout;

-(void) documentDidLayout;

-(void) documentDidVisable;

@end

@protocol VTURLDocumentControllerDelegate

@optional

-(void) vtURLDocumentControllerWillLoading:(VTURLDocumentController *) controller;

-(void) vtURLDocumentController:(VTURLDocumentController *) controller doActionElement:(VTDOMElement *) element;

-(void) vtURLDocumentControllerDidLoaded:(VTURLDocumentController *) controller;

-(void) vtURLDocumentController:(VTURLDocumentController *) controller didFailWithError:(NSError *) error;

-(void) vtURLDocumentController:(VTURLDocumentController *) controller willReloadElement:(VTDOMElement *)element queryValues:(NSMutableDictionary *) queryValues;

-(void) vtURLDocumentControllerDidDocumentLoaded:(VTURLDocumentController *) controller;

-(UIView *) vtURLDocumentController:(VTURLDocumentController *) controller elementView:(VTDOMElement *)element viewClass:(Class) viewClass;

@end