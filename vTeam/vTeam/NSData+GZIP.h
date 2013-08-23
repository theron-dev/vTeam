//
//  NSData+GZIP.h
//  vTeam
//
//  Created by zhang hailong on 13-8-23.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GZIP)

-(NSData *) GZIPEncode;

-(NSData *) GZIPDecode;

@end
