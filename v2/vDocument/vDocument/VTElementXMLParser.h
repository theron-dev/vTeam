//
//  VTElementXMLParser.h
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vDocument/VTElement.h>

@interface VTElementXMLParser : NSObject<NSXMLParserDelegate>

-(void) loadLibrarys;

-(void) setElementClass:(Class) clazz forName:(NSString *) name;

-(VTElement *) parse:(NSXMLParser *) parser;

@end
