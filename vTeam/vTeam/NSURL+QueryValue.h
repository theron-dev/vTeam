//
//  NSURL+QueryValue.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (QueryValue)

@property(nonatomic,readonly) NSDictionary * queryValues;


+ (id)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL queryValues:(id) queryValues;

+ (id)URLWithString:(NSString *)URLString queryValues:(id) queryValues;

+ (NSString *) decodeQueryValue:(NSString *) queryValue;

+ (NSString *) encodeQueryValue:(NSString *) queryValue;

+ (NSDictionary *) decodeQuery:(NSString *) query;

+ (NSString *) encodeQueryValues:(NSDictionary *) queryValues;

-(NSString *) firstPathComponent;

-(NSString *) firstPathComponent:(NSString *) basePath;

-(NSArray *) pathComponents:(NSString *) basePath;

@end
