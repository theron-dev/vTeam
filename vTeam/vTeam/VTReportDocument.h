//
//  VTReportDocument.h
//  vTeam
//
//  Created by zhang hailong on 13-6-8.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

struct _ReportDocument;

@interface VTReportDocument : NSObject

@property(nonatomic,readonly) struct _ReportDocument * cDocument;

-(id) initWithFilePath:(NSString *) filePath;

-(id) initWithData:(NSData *) data;

@end
