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

@interface VTDOMDocument : NSObject

@property(nonatomic,retain) NSBundle * bundle;
@property(nonatomic,retain) VTDOMElement * rootElement;
@property(nonatomic,retain) VTDOMStyleSheet * styleSheet;
@property(nonatomic,retain) NSIndexPath * indexPath;

-(VTDOMElement *) elementById:(NSString *) eid;

-(NSArray *) elementsByClass:(Class) clazz inherit:(BOOL)inherit;

-(void) applyStyleSheet:(VTDOMElement *) element;

-(void) applyStyleSheet;

@end
