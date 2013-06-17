//
//  VTFDB.h
//  vTeam
//
//  Created by zhang hailong on 13-6-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VTFDBIndex.h"

struct _FDBProperty ;
struct _FDBClass;
struct _FDB;


@protocol IVTFDBCursor <NSObject>

-(void *) nextDataItem;

-(BOOL) commit;

@end

@class VTFDB;

typedef BOOL (^VTFDBFilter)(VTFDB * fdb,id<IVTFDBCursor> cursor,void * dataItem);

@interface VTFDB : NSObject

@property(nonatomic,assign) NSUInteger maxBufferCount;
@property(nonatomic,readonly) struct _FDB * fdb;
@property(nonatomic,readonly) struct _FDBClass * dbClass;
@property(nonatomic,readonly) NSString * dbPath;

-(id) initWithPath:(NSString *) dbPath;

-(struct _FDBProperty *) getProperty:(NSString *) name;

-(void *) dataItemOfRowid:(int) rowid;

-(id<IVTFDBCursor>) query;

-(id<IVTFDBCursor>) queryFilter:(VTFDBFilter) filter;

-(void) close;

-(int) intValue:(void *) dataItem property:(struct _FDBProperty *) property;

-(long long) longLongValue:(void *) dataItem property:(struct _FDBProperty *) property;

-(double) doubleValue:(void *) dataItem property:(struct _FDBProperty *) property;

-(NSString *) stringValue:(void *) dataItem property:(struct _FDBProperty *) property;

-(NSData *) dataValue:(void *) dataItem property:(struct _FDBProperty *) property;

-(VTFDBIndex *) openIndex:(NSString *) indexName;

@end
