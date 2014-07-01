//
//  VTFDBIndex.h
//  vTeam
//
//  Created by zhang hailong on 13-6-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@class VTFDB;

struct _FDBIndex;
struct _FDBIndexDB;

typedef enum _VTFDBIndexQueryMode {
    VTFDBIndexQueryModeAsc = -1,VTFDBIndexQueryModeDesc = 1
} VTFDBIndexQueryMode;

typedef enum _VTFDBIndexQueryStringMatch {
    VTFDBIndexQueryStringMatchEqual,VTFDBIndexQueryStringMatchPrefix
} VTFDBIndexQueryStringMatch;

@protocol IVTFDBIndexCursor <NSObject>

-(void *) nextIndexItem;

-(void *) getDataItem:(void *) indexItem;

@end

@interface VTFDBIndex : NSObject

@property(nonatomic,readonly) VTFDB * db;
@property(nonatomic,readonly) struct _FDBIndex * cIndex;
@property(nonatomic,readonly) struct _FDBIndexDB * dbIndex;
@property(nonatomic,assign) NSUInteger maxBufferLength;

-(id) initWithDB:(VTFDB *) db indexName:(NSString *) indexName;

-(struct _FDBProperty *) getProperty:(NSString *) name;

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value;

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode;

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode stringMatch:(VTFDBIndexQueryStringMatch) stringMatch;


-(id<IVTFDBIndexCursor>) query;

-(void) close;

@end
