//
//  VTFDB.m
//  vTeam
//
//  Created by zhang hailong on 13-6-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFDB.h"

#include "hconfig.h"
#include "hfdb.h"


@interface VTFDB(){
    FDBCursor _cursor;
    NSMutableDictionary * _indexs;
}


@end

typedef struct _VTFDBCursorInternal{
    FDBCursor base;
    id vt;
    id fdb;
    VTFDBFilter filter;
} VTFDBCursorInternal;

@interface VTFDBCursor : NSObject<IVTFDBCursor>{
    VTFDBCursorInternal _cursor;
}

@property(assign) VTFDB * fdb;

-(id) initWithFDB:(VTFDB *) fdb;

-(id) initWithFDB:(VTFDB *) fdb filter:(VTFDBFilter) filter;

@end

@implementation VTFDBCursor


-(void) dealloc{
    if(_cursor.base.data.dbClass){
        FDBDataDelete(&_cursor.base.data);
    }
    [super dealloc];
}

-(void *) nextDataItem{
    if(_cursor.fdb){
        return FDBCursorNext([_cursor.fdb fdb],& _cursor.base);
    }
    return nil;
}


-(BOOL) commit{
    if(_cursor.fdb){
        return FDB_OK == FDBCursorCommit([_cursor.fdb fdb],& _cursor.base);
    }
    return NO;
}

-(id) initWithFDB:(VTFDB *) fdb{
    if(self = [super init]){
        FDBDataCreate(&_cursor.base.data,fdb.dbClass);
        NSUInteger bufferCount = fdb.maxBufferCount;
        if(bufferCount == 0){
            bufferCount = 200;
        }
        FDBDataSetLength(&_cursor.base.data,(huint32) bufferCount);
        _cursor.fdb = fdb;
        _cursor.vt = self;
    }
    return self;
}

static hbool VTFDBCursorFilter (FDB * fdb,struct _FDBCursor * cursor,FDBDataItem dataItem){
    VTFDBCursorInternal * internal = (VTFDBCursorInternal *) cursor;
    VTFDBFilter filter = internal->filter;
    return filter(internal->fdb,internal->vt,dataItem) ? hbool_true: hbool_false;
}


-(id) initWithFDB:(VTFDB *) fdb filter:(VTFDBFilter) filter{
    if(self = [self initWithFDB:fdb]){
        _cursor.filter = filter;
        _cursor.base.filter = VTFDBCursorFilter;
    }
    return self;
}

-(void) setFdb:(VTFDB *) fdb{
    _cursor.fdb = fdb;
}

-(VTFDB *) fdb{
    return _cursor.fdb;
}

@end



@implementation VTFDB

@synthesize fdb = _fdb;
@synthesize maxBufferCount = _maxBufferCount;
@synthesize dbPath = _dbPath;

-(id) initWithPath:(NSString *) dbPath{
    if((self = [super init])){
        _dbPath = [dbPath retain];
        _fdb = FDBOpen([dbPath UTF8String]);
        if(_fdb == nil){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    [self close];
    if(_cursor.data.dbClass){
        FDBDataDelete(&_cursor.data);
    }
    [_dbPath release];
    [super dealloc];
}


-(struct _FDBProperty *) getProperty:(NSString *) name{
    if(_fdb){
        return FDBClassGetProperty(_fdb->dbClass,[name UTF8String]);
    }
    return nil;
}

-(void *) dataItemOfRowid:(int) rowid{
    
    if(_fdb){
        
        if(_cursor.data.dbClass == nil){
            FDBDataCreate(&_cursor.data,_fdb->dbClass);
            if(_maxBufferCount == 0){
                _maxBufferCount = 200;
            }
            FDBDataSetLength(&_cursor.data,(huint32)_maxBufferCount);
        }
        
        return FDBCursorToRowid(_fdb,&_cursor,rowid);
    }
    
    return nil;
}

-(id<IVTFDBCursor>) query{
    if(_fdb){
        
        VTFDBCursor * cursor = [[VTFDBCursor alloc] initWithFDB:self];
        
        
        return [cursor autorelease];
        
    }
    return nil;
}

-(id<IVTFDBCursor>) queryFilter:(VTFDBFilter) filter{
    if(_fdb){
        
        VTFDBCursor * cursor = [[VTFDBCursor alloc] initWithFDB:self filter:filter];
        
        
        return [cursor autorelease];
        
    }
    return nil;
}

-(void) close{
    for(VTFDBIndex * index in [_indexs allValues]){
        [index close];
    }
    [_indexs removeAllObjects];
    if(_fdb){
        FDBClose(_fdb);
        _fdb = NULL;
    }
}

-(void *) blobValue:(long long) value length:(NSUInteger *) length{
    if(_fdb){
        return FDBBlobRead(_fdb,value,(huint32 *) length);
    }
    return NULL;
}

-(NSString *) blobStringValue:(long long) value{
    if(_fdb){
        void * v = FDBBlobRead(_fdb,value,NULL);
        return v ? [NSString stringWithCString:v encoding:NSUTF8StringEncoding] : nil;
    }
    return NULL;
}

-(struct _FDBClass *) dbClass{
    return _fdb->dbClass;
}

-(int) intValue:(void *) dataItem property:(struct _FDBProperty *) property{
    if(!dataItem || ! property){
        return 0;
    }
    return FDBClassGetPropertyInt32Value(dataItem, property, 0);
}

-(long long) longLongValue:(void *) dataItem property:(struct _FDBProperty *) property{
    if(!dataItem || ! property){
        return 0;
    }
    return FDBClassGetPropertyInt64Value(dataItem, property, 0);
}

-(double) doubleValue:(void *) dataItem property:(struct _FDBProperty *) property{
    if(!dataItem || ! property){
        return 0.0;
    }
    return FDBClassGetPropertyDoubleValue(dataItem, property, 0.0);
}

-(NSString *) stringValue:(void *) dataItem property:(struct _FDBProperty *) property{
    if(!dataItem || ! property){
        return nil;
    }
    switch (property->type) {
        case FDBPropertyTypeInt32:
            return [NSString stringWithFormat:@"%d",FDBClassGetPropertyInt32Value(dataItem, property, 0)];
            break;
        case FDBPropertyTypeInt64:
            return [NSString stringWithFormat:@"%lld",FDBClassGetPropertyInt64Value(dataItem, property, 0)];
            break;
        case FDBPropertyTypeDouble:
            return [NSString stringWithFormat:@"%f",FDBClassGetPropertyDoubleValue(dataItem, property, 0.0)];
            break;
        case FDBPropertyTypeString:
        {
            const char * v = FDBClassGetPropertyStringValue(dataItem, property, nil);
            return v ? [NSString stringWithCString:v encoding:NSUTF8StringEncoding] : nil;
        }
            break;
        case FDBPropertyTypeBlob:
        {
            FDBBlobValue v = FDBClassGetPropertyBlobValue(dataItem, property, 0);
            if(!v){
                return nil;
            }
            
            void * p = FDBBlobRead(_fdb,v,NULL);
            
            if(!p){
                return nil;
            }
            
            return [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSData *) dataValue:(void *) dataItem property:(struct _FDBProperty *) property{
    
    if(!dataItem || ! property){
        return nil;
    }
    
    switch (property->type) {
        case FDBPropertyTypeBlob:
        {
            FDBBlobValue v = FDBClassGetPropertyBlobValue(dataItem, property, 0);
            
            if(!v){
                return nil;
            }
            
            huint32 length = 0;
            void * p = FDBBlobRead(_fdb,v,&length );
            
            if(!p){
                return nil;
            }
            
            if(length == 0){
                return nil;
            }
            
            return [NSData dataWithBytes:p length:length];
        }
            break;
        default:
            break;
    }
    return nil;
}

-(VTFDBIndex *) openIndex:(NSString *) indexName{
    
    VTFDBIndex * index = [_indexs objectForKey:indexName];
    
    if(index == nil || [index dbIndex] == nil){
        index = [[[VTFDBIndex alloc] initWithDB:self indexName:indexName] autorelease];
        if(index){
            if(_indexs == nil){
                _indexs = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            [_indexs setObject:index forKey:indexName];
        }
    }
    
    return index;
}

@end
