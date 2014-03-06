//
//  VTFDBIndex.m
//  vTeam
//
//  Created by zhang hailong on 13-6-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFDBIndex.h"

#import <vTeam/VTFDB.h>

#include "hconfig.h"
#include "hfdb.h"
#include "hfdb_index.h"

@interface VTFDBIndex(){
    FDBIndexDB * _indexDB;
}


@end

typedef struct _VTFDBIndexCursorInternal{
    FDBIndexCursor base;
    id vt;
    id dbIndex;
    FDBIndexCursorProperty property;
} VTFDBIndexCursorInternal;

@interface VTFDBIndexCursor : NSObject<IVTFDBIndexCursor>{
    VTFDBIndexCursorInternal _cursor;
    BOOL _inited;
}

@property(assign) VTFDBIndex * dbIndex;
@property(nonatomic,retain) id propertyValue;

-(id) initWithDBIndex:(VTFDBIndex *) dbIndex;

-(id) initWithDBIndex:(VTFDBIndex *) dbIndex property:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode stringMatch:(VTFDBIndexQueryStringMatch) stringMatch;

@end

@implementation VTFDBIndexCursor

@synthesize propertyValue = _propertyValue;

-(void) dealloc{
    if(_cursor.base.data.index){
        FDBIndexDataDelete(&_cursor.base.data);
    }
    [_propertyValue release];
    [super dealloc];
}

-(void *) nextIndexItem{
    if(_cursor.dbIndex){
        if(_cursor.property.property){
            if(!_inited){
                _inited = YES;
                return FDBIndexCursorToBeginPropertys([_cursor.dbIndex dbIndex], & _cursor.base, & _cursor.property, 1);
            }
            return FDBIndexCursorToNextPropertys([_cursor.dbIndex dbIndex], & _cursor.base, & _cursor.property, 1);
        }
        else {
            if(!_inited){
                _inited = YES;
                return FDBIndexCursorToBegin([_cursor.dbIndex dbIndex], & _cursor.base, NULL, NULL);
            }
            return FDBIndexCursorToNext([_cursor.dbIndex dbIndex], & _cursor.base, NULL, NULL);
        }
    }
    return nil;
}

-(void *) getDataItem:(void *) indexItem{
    if(_cursor.dbIndex){
        int rowid = FDBClassGetPropertyInt32Value(indexItem, & [_cursor.dbIndex cIndex]->rowid, 0);
        if(rowid){
            return [[_cursor.dbIndex db] dataItemOfRowid:rowid];
        }
    }
    return nil;
}


-(id) initWithDBIndex:(VTFDBIndex *) dbIndex{
    if(self = [super init]){
        FDBIndexDataCreate(&_cursor.base.data, dbIndex.cIndex);
        NSUInteger bufferCount = dbIndex.maxBufferLength;
        if(bufferCount == 0){
            bufferCount = 2000;
        }
        FDBIndexDataExpandSize(&_cursor.base.data, (huint32) bufferCount);
        _cursor.dbIndex = dbIndex;
        _cursor.vt = self;
    }
    return self;
}

-(id) initWithDBIndex:(VTFDBIndex *) dbIndex property:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode stringMatch:(VTFDBIndexQueryStringMatch) stringMatch{
    if(self = [self initWithDBIndex:dbIndex]){
        _cursor.property.property =property;
        _cursor.property.mode = (FDBIndexCompareOrder) mode;
        _cursor.property.stringMatch = (FDBIndexCursorPropertyStringMatch) stringMatch;
        self.propertyValue = value;
        switch (property->type) {
            case FDBPropertyTypeInt32:
                _cursor.property.int32Value = [value intValue];
                break;
            case FDBPropertyTypeInt64:
                _cursor.property.int64Value = [value longLongValue];
                break;
            case FDBPropertyTypeDouble:
                _cursor.property.doubleValue = [value doubleValue];
                break;
            case FDBPropertyTypeString:
                _cursor.property.stringValue = [value UTF8String];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void) setDbIndex:(VTFDBIndex *)dbIndex{
    _cursor.dbIndex = dbIndex;
}

-(VTFDBIndex *) dbIndex{
    return _cursor.dbIndex;
}

@end

@implementation VTFDBIndex

@synthesize db = _db;
@synthesize maxBufferLength = _maxBufferLength;
-(id) initWithDB:(VTFDB *) db indexName:(NSString *) indexName{
    if((self =[super init])){
        _maxBufferLength = 2000;
        _db = db;
        _indexDB = FDBIndexOpen([db.dbPath UTF8String], [indexName UTF8String]);
        if(_indexDB == nil){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    if(_indexDB){
        FDBIndexClose(_indexDB);
    }
    [super dealloc];
}

-(struct _FDBIndex *) cIndex{
    if(_indexDB == nil){
        return nil;
    }
    return _indexDB->index;
}

-(struct _FDBIndexDB *) dbIndex{
    return _indexDB;
}

-(struct _FDBProperty *) getProperty:(NSString *) name{
    if(_indexDB == nil){
        return nil;
    }
    return FDBIndexGetProperty(_indexDB->index, [name UTF8String]);
}

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value{
    return [self queryProperty:property value:value mode:VTFDBIndexQueryModeAsc stringMatch:VTFDBIndexQueryStringMatchEqual];
}

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode{
    return [self queryProperty:property value:value mode:mode stringMatch:VTFDBIndexQueryStringMatchEqual];
}

-(id<IVTFDBIndexCursor>) queryProperty:(struct _FDBProperty *) property value:(id) value mode:(VTFDBIndexQueryMode) mode stringMatch:(VTFDBIndexQueryStringMatch) stringMatch{

    if(_indexDB && property){
        
        VTFDBIndexCursor * cursor = [[VTFDBIndexCursor alloc] initWithDBIndex:self property:property value:value mode:mode stringMatch:stringMatch];

        return [cursor autorelease];
        
    }
    return nil;
}

-(id<IVTFDBIndexCursor>) query{
    if(_indexDB){
        
        VTFDBIndexCursor * cursor = [[VTFDBIndexCursor alloc] initWithDBIndex:self];
        
        return [cursor autorelease];
        
    }
    return nil;
}

-(void) close{
    if(_indexDB){
        FDBIndexClose(_indexDB);
        _indexDB = NULL;
    }
}


@end
