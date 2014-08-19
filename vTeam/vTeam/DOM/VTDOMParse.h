//
//  VTDOMParse.h
//  vTeam
//
//  Created by zhang hailong on 13-8-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VTDOMElement;
@class VTDOMDocument;
@class VTDOMStyleSheet;

@interface VTDOMParse : NSObject

-(VTDOMElement *) newElement:(NSString *) name ns:(NSString *) ns;

-(BOOL) parseHTML:(NSString *) html toElement:(VTDOMElement *) element atIndex:(NSInteger) index;

-(BOOL) parseHTML:(NSString *) html toElement:(VTDOMElement *) element;

-(BOOL) parseHTML:(NSString *) html toDocument:(VTDOMDocument *) document;

-(BOOL) parseCSS:(NSString *) css toStyleSheet:(VTDOMStyleSheet *) styleSheet;

-(BOOL) parseXML:(NSString *) xml toElement:(VTDOMElement *) element atIndex:(NSInteger) index;

-(BOOL) parseXML:(NSString *) xml toElement:(VTDOMElement *) element;

-(BOOL) parseXML:(NSString *) xml toDocument:(VTDOMDocument *) document;

@end
