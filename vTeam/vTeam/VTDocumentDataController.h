//
//  VTDocumentDataController.h
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTTableDataController.h>
#import <vTeam/VTDOMView.h>
#import <vTeam/VTDOMDocument.h>

@interface VTDocumentDataController : VTTableDataController<VTDOMViewDelegate>

@property(nonatomic,retain) NSBundle * bundle;
@property(nonatomic,retain) NSString * html;
@property(nonatomic,retain) NSURL * documentURL;
@property(nonatomic,retain) id dataItem;
@property(nonatomic,retain) UIColor * selectedBackgroundColor;

-(VTDOMDocument *) documentByIndexPath:(NSIndexPath *) indexPath;

-(void) document:(VTDOMDocument *) document didLoadedDataObject:(id) dataObject;

-(void) document:(VTDOMDocument *) document willLoadDataObject:(id) dataObject;

-(NSString *) htmlContentByIndexPath:(NSIndexPath *) indexPath;

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath;

-(void) downloadImagesForElement:(VTDOMElement *) element;

-(void) loadImagesForElement:(VTDOMElement *) element;

-(void) removeDocumentByIndexPath:(NSIndexPath *) indexPath;

-(void) layoutDocumentByIndexPath:(NSIndexPath *) indexPath;


@end

@protocol VTDocumentDataControllerDelegate <VTTableDataControllerDelegate>

@optional

-(void) vtDocumentDataController:(VTDocumentDataController *) dataController element:(VTDOMElement *) element
                        doAction:(id<IVTAction>) action;

@end
