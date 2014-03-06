//
//  VTReportDocument.m
//  vTeam
//
//  Created by zhang hailong on 13-6-8.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTReportDocument.h"

#include "hconfig.h"
#include "hreport.h"

@interface VTReportDocument(){
    ReportDocument * _document;
}

@end

@implementation VTReportDocument

-(struct _ReportDocument *) cDocument{
    return _document;
}

-(void) dealloc{
    if(_document){
        ReportDocumentDelete(_document);
    }
    [super dealloc];
}

-(id) initWithFilePath:(NSString *) filePath{
    if((self = [super init])){
        _document = ReportDocumentCreateFilePath([filePath UTF8String]);
        if(_document == nil){
            [self release];
            return nil;
        }
    }
    return self;
}

-(id) initWithData:(NSData *) data{
    if((self = [super init])){
        _document = ReportDocumentCreateBytes([data bytes], (huint32)[data length]);
        if(_document == nil){
            [self release];
            return nil;
        }
    }
    return self;
}

@end
