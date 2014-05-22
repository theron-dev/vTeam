//
//  VTDOMDocument.h
//  vTeam
//
//  Created by zhang hailong on 13-8-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTDOMElement.h>
#import <vTeam/VTDOMStyleSheet.h>

#define VTDOMDocumentVersion    @"1.0.0"

@interface VTDOMDocument : NSObject

@property(nonatomic,retain) NSBundle * bundle;
@property(nonatomic,retain) VTDOMElement * rootElement;
@property(nonatomic,retain) VTDOMStyleSheet * styleSheet;
@property(nonatomic,retain) NSIndexPath * indexPath;
@property(nonatomic,retain) NSURL * documentURL;

-(VTDOMElement *) elementById:(NSString *) eid;

-(NSArray *) elementsByClass:(Class) clazz inherit:(BOOL)inherit;

-(void) applyStyleSheet:(VTDOMElement *) element;

-(void) applyStyleSheet;

@end
