//
//  VTElementParser.m
//  vElement
//
//  Created by zhang hailong on 14-6-30.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTElementParser.h"

#include <libxml/parser.h>

#include <libxml/tree.h>

@implementation VTElementParser

-(BOOL) parseXML:(NSString *) xmlContent url:(NSURL *) url toElement:(VTElement *) element atIndex:(NSUInteger) index{
    
    
    NSXMLParser
    xmlDocPtr doc;
    
    doc = xmlReadDoc((const xmlChar *)[xmlContent UTF8String], [[url absoluteString] UTF8String]
                     , "utf-8", XML_PARSE_RECOVER);
    
    if(doc == nil){
        return NO;
    }
    
    
    return YES;
}

@end
