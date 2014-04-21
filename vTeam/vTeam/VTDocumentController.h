//
//  VTDocumentController.h
//  vTeam
//
//  Created by zhang hailong on 13-11-20.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTController.h>
#import <vTeam/VTDOMDocument.h>
#import <vTeam/VTDOMView.h>

@interface VTDocumentController : VTController<VTDOMViewDelegate>

@property(nonatomic,retain) IBOutlet UIView * documentView;
@property(nonatomic,retain) NSString * html;
@property(nonatomic,retain) NSBundle * bundle;
@property(nonatomic,retain) id dataItem;
@property(nonatomic,retain) VTDOMDocument * document;
@property(nonatomic,assign,getter = isAllowAutoHeight) BOOL allowAutoHeight;
@property(nonatomic,assign,getter = isAllowAutoWidth) BOOL allowAutoWidth;
@property(nonatomic,readonly) CGSize contentSize;
@property(nonatomic,readonly,getter = isDocumentLoaded) BOOL documentLoaded;
@property(nonatomic,assign,getter = isLoading) BOOL loading;

-(void) documentWillLoad;

-(void) documentDidLoad;

-(void) documentWillLayout;

-(void) documentDidLayout;

-(NSString *) htmlContent;

-(BOOL) hasDocumentDynamicDataBind;

-(void) documentDynamicDataBind;

-(void) downloadImagesForElement:(VTDOMElement *) element;

-(void) loadImagesForElement:(VTDOMElement *) element;

-(void) downloadImagesForView:(UIView *) view;

-(void) loadImagesForView:(UIView *) view;

-(void) cancelDownloadImagesForView:(UIView *) view;

-(void) reloadData;

-(void) onActionElement:(VTDOMElement *) element;

-(void) documentLayout;

-(void) startLoading;

-(void) stopLoading;

@end

@protocol VTDocumentControllerDelegate

@optional

-(void) vtDocumentController:(VTDocumentController *) controller doActionElement:(VTDOMElement *) element;

@end