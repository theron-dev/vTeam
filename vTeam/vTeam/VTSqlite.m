//
//  VTSqlite.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTSqlite.h"

#include <sqlite3.h>
#include <objc/runtime.h>

#import "VTJSON.h"

static void VTSqliteStmtBindData(sqlite3_stmt * stmt,id data,sqlite3_destructor_type type);

@interface VTSqliteCursor : NSObject<IVTSqliteCursor>{
    sqlite3_stmt * _stmt;
    NSMutableDictionary * _indexOfNames;
}

@property(nonatomic,assign) VTSqlite * sqlite;
@property(nonatomic,readonly) NSMutableDictionary * indexOfNames;

-(id) initWithStmt:(sqlite3_stmt *) stmt sqlite:(VTSqlite *) sqlite;

@end


@interface VTSqlite(){
    sqlite3 * _sqlite;
    NSMutableArray * _cursurs;
}

-(void) removeCursor:(VTSqliteCursor *) cursor;

@end


@implementation VTSqliteCursor

@synthesize sqlite = _sqlite;
@synthesize closed = _closed;

-(void) dealloc{
    [self close];
    [_indexOfNames release];
    [super dealloc];
}

-(void) close{
    if(!_closed){
        if(_stmt){
            sqlite3_finalize(_stmt);
            _stmt = NULL;
        }
        _closed = YES;
        [_sqlite removeCursor:self];
    }
}

-(BOOL) reset{
    if(_stmt){
        return sqlite3_reset(_stmt) == SQLITE_OK;
    }
    return NO;
}

-(id) initWithStmt:(sqlite3_stmt *)stmt sqlite:(VTSqlite *)sqlite{
    if((self = [super init])){
        _stmt = stmt;
        _sqlite = sqlite;
    }
    return self;
}

-(BOOL) next{
    if(_stmt){
        return sqlite3_step(_stmt) == SQLITE_ROW;
    }
    return NO;
}

-(NSMutableDictionary *) indexOfNames{
    if(_indexOfNames == nil && _stmt){
        _indexOfNames = [[NSMutableDictionary alloc] initWithCapacity:4];
        int c = sqlite3_column_count(_stmt);
        for(int i=0;i<c;i++){
            [_indexOfNames setValue:[NSNumber numberWithInt:i] forKey:[NSString stringWithCString:sqlite3_column_name(_stmt, i) encoding:NSUTF8StringEncoding]];
        }
    }
    return _indexOfNames;
}

-(int) count{
    return sqlite3_column_count(_stmt);
}

-(int) columnCount{
    return sqlite3_column_count(_stmt);
}

-(int) columnIndexForName:(NSString *) name{
    id index = [[self indexOfNames] valueForKey:name];
    return index == nil ? -1 : [index intValue];
}

-(NSString *) columnNameAtIndex:(int) index{
    const char * cString = sqlite3_column_name(_stmt, index);
    return cString ? [NSString stringWithCString:cString encoding:NSUTF8StringEncoding] : nil;
}

-(int) intValueForName:(NSString *) name{
    return [self intValueAtIndex:[self columnIndexForName:name]];
}

-(int) intValueAtIndex:(int) index{
    if(_stmt){
        return sqlite3_column_int(_stmt, index);
    }
    return 0;
}

-(long) longValueForName:(NSString *) name{
    return [self longValueAtIndex:[self columnIndexForName:name]];
}

-(long) longValueAtIndex:(int) index{
    if(_stmt){
        return sqlite3_column_int(_stmt, index);
    }
    return 0;
}

-(long long) longLongValueForName:(NSString *) name{
    return [self longLongValueAtIndex:[self columnIndexForName:name]];
}

-(long long) longLongValueAtIndex:(int) index{
    if(_stmt){
        return sqlite3_column_int64(_stmt, index);
    }
    return 0;
}

-(BOOL) boolValueForName:(NSString *) name{
    return [self boolValueAtIndex:[self columnIndexForName:name]];
}

-(BOOL) boolValueAtIndex:(int) index{
    if(_stmt){
        return sqlite3_column_int(_stmt, index) != 0;
    }
    return NO;
}

-(double) doubleValueForName:(NSString *) name{
    return [self doubleValueAtIndex:[self columnIndexForName:name]];
}

-(double) doubleValueAtIndex:(int) index{
    if(_stmt){
        return sqlite3_column_double(_stmt, index);
    }
    return 0.0;
}

-(NSString *) stringValueForName:(NSString *) name{
    return [self stringValueAtIndex:[self columnIndexForName:name]];
}

-(NSString *) stringValueAtIndex:(int) index{
    if(_stmt){
        const char * cString = (const char *) sqlite3_column_text(_stmt, index);
        return cString ? [NSString stringWithCString:cString encoding:NSUTF8StringEncoding] : nil;
    }
    return nil;
}

-(NSDate *) dateValueForName:(NSString *) name{
    return [self dateValueAtIndex:[self columnIndexForName:name]];
}

-(NSDate *) dateValueAtIndex:(int) index{
    if(_stmt){
        return [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(_stmt, index)];
    }
    return nil;
}

-(NSData *) dataValueForName:(NSString *) name{
    return [self dataValueAtIndex:[self columnIndexForName:name]];
}

-(NSData * ) dataValueAtIndex:(int) index{
    if(_stmt){
        const void * data = sqlite3_column_blob(_stmt, index);
        int bytes = sqlite3_column_bytes(_stmt, index);
        if(data && bytes >0){
            return [NSData dataWithBytes:data length:bytes];
        }
    }
    return nil;
}

-(const char *) cStringValueForName:(NSString *) name{
    return [self cStringValueAtIndex:[self columnIndexForName:name]];
}

-(const char *) cStringValueAtIndex:(int) index{
    if(_stmt){
        return (const char *) sqlite3_column_text(_stmt, index);
    }
    return nil;
}

-(id) valueForKey:(NSString *) key{
    return [self objectAtIndex:[self columnIndexForName:key]];
}

-(id) objectAtIndex:(NSUInteger) index{
    
    int columnType = sqlite3_column_type(_stmt, (int)index);
    
    id returnValue = nil;
    
    if (columnType == SQLITE_INTEGER) {
        returnValue = [NSNumber numberWithLongLong:[self longLongValueAtIndex:(int)index]];
    }
    else if (columnType == SQLITE_FLOAT) {
        returnValue = [NSNumber numberWithDouble:[self doubleValueAtIndex:(int)index]];
    }
    else if (columnType == SQLITE_BLOB) {
        returnValue = [self dataValueAtIndex:(int)index];
    }
    else {
        returnValue = [self stringValueAtIndex:(int)index];
    }
    
    return returnValue;
}

-(id) valueForProperty:(objc_property_t) prop{
    
    const char * t = property_getAttributes(prop);
    
    NSString * type = [NSString stringWithCString:t encoding:NSUTF8StringEncoding];
    NSString * name = [NSString stringWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
    
    if([type hasPrefix:@"Ti"]){
        return [NSNumber numberWithInt:[self intValueForName:name]];
    }
    
    if([type hasPrefix:@"Tl"]){
        return [NSNumber numberWithLong:[self longValueForName:name]];
    }
    
    if([type hasPrefix:@"Tq"]){
        return [NSNumber numberWithLongLong:[self longLongValueForName:name]];
    }
    
    if([type hasPrefix:@"Td"] || [type hasPrefix:@"Tf"]){
        return [NSNumber numberWithDouble:[self doubleValueForName:name]];
    }
    
    if([type hasPrefix:@"Tb"] ){
        return [NSNumber numberWithBool:[self boolValueForName:name]];
    }
    
    if([type hasPrefix:@"T@\"NSString\""]){
        return [self stringValueForName:name];
    }
    
    if([type hasPrefix:@"T@\"NSData\""]){
        return [self dataValueForName:name];
    }
    
    if([type hasPrefix:@"T@\"NSDate\""]){
        return [self dateValueForName:name];
    }
    
    if([type hasPrefix:@"T@"]){
        NSData * data = [self dataValueForName:name];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id v = [VTJSON decodeText:str];
        [str release];
        return v;
    }
    
    return [self stringValueForName:name];    
}

-(void) toDataObject:(id) dataObject forClass:(Class) dataObjectClass{
    
    if(dataObject){
        Class clazz = dataObjectClass;
        while(clazz && clazz != [NSObject class]){
            unsigned int propCount = 0;
            objc_property_t * prop =  class_copyPropertyList(clazz, &propCount);
            for(int i=0;i<propCount;i++){
                NSString * name = [NSString stringWithCString:property_getName(prop[i]) encoding:NSUTF8StringEncoding];
                [dataObject setValue:[self valueForProperty:prop[i]] forKey:name];
            }
            free(prop);
            clazz = class_getSuperclass(clazz);
        }
    }
}

-(void) toDataObject:(id) object{
    if(object){
        
        if([object isKindOfClass:[NSMutableDictionary class]]) {
            int c = [self count];
            for(int i=0;i<c;i++){
                [object setValue:[self objectAtIndex:i] forKey:[self columnNameAtIndex:i]];
            }
        }
        else{
            Class clazz = [object class];
            while(clazz && clazz != [NSObject class]){
                unsigned int propCount = 0;
                objc_property_t * prop =  class_copyPropertyList(clazz, &propCount);
                for(int i=0;i<propCount;i++){
                    NSString * name = [NSString stringWithCString:property_getName(prop[i]) encoding:NSUTF8StringEncoding];
                    [object setValue:[self valueForProperty:prop[i]] forKey:name];
                }
                free(prop);
                clazz = class_getSuperclass(clazz);
            }
        }
    }
}

-(NSArray *) dataObjects:(Class) dataObjectClass{
    NSMutableArray * rs = [NSMutableArray arrayWithCapacity:4];
    while([self next]){
        id dataObject = [[dataObjectClass alloc] init];
        if(dataObject){
            [self toDataObject:dataObject];
            [rs addObject:dataObject];
        }
        [dataObject release];
    }
    return rs;
}

@end

@interface VTSqliteUnionCursor (){
    NSInteger _index;
}

-(id) currentCursor;

@end

@implementation VTSqliteUnionCursor

@synthesize cursors = _cursors;
@synthesize closed = _closed;

-(void) dealloc{
    [_cursors release];
    [super dealloc];
}


-(id) initWithCursors:(NSArray *)cursors{
    if((self = [super init])){
        _cursors = [cursors retain];
        _index = -1;
    }
    return self;
}

-(void) close{
    if(!_closed){
        for(id cursor in _cursors){
            [cursor close];
        }
        _closed = YES;
    }
}

-(id) currentCursor{
    if(_index >=0 && _index < [_cursors count]){
        return [_cursors objectAtIndex:_index];
    }
    return nil;
}

-(BOOL) reset{
    BOOL rs = YES;
    for(id cursor in _cursors){
        if(![cursor reset]){
            rs = NO;
        }
    }
    return rs;
}

-(BOOL) next{
    
    NSInteger eofCount = 0;
    NSInteger c = [_cursors count];

    if(c >0){
        while(eofCount < c){
            _index = (_index + 1) % [_cursors count];
            if([[self currentCursor] next]){
                return YES;
            }
            else{
                eofCount ++;
            }
        }
    }
    
    return NO;
}

-(int) count{
    return [(id<IVTSqliteCursor>)[self currentCursor] count];
}

-(int) columnCount{
    return [(id<IVTSqliteCursor>)[self currentCursor] count];
}

-(int) columnIndexForName:(NSString *) name{
    return [[self currentCursor] columnIndexForName:name];
}

-(NSString *) columnNameAtIndex:(int) index{
    return [[self currentCursor] columnNameAtIndex:index];
}

-(int) intValueForName:(NSString *) name{
    return [[self currentCursor] intValueForName:name];
}

-(int) intValueAtIndex:(int) index{
    return [[self currentCursor] intValueAtIndex:index];
}

-(long) longValueForName:(NSString *) name{
    return [[self currentCursor] longValueForName:name];
}

-(long) longValueAtIndex:(int) index{
    return [[self currentCursor] longValueAtIndex:index];
}

-(long long) longLongValueForName:(NSString *) name{
    return [[self currentCursor] longLongValueForName:name];
}

-(long long) longLongValueAtIndex:(int) index{
    return [[self currentCursor] longLongValueAtIndex:index];
}

-(BOOL) boolValueForName:(NSString *) name{
    return [[self currentCursor] boolValueForName:name];
}

-(BOOL) boolValueAtIndex:(int) index{
    return [[self currentCursor] boolValueAtIndex:index];
}

-(double) doubleValueForName:(NSString *) name{
    return [[self currentCursor] doubleValueForName:name];
}

-(double) doubleValueAtIndex:(int) index{
    return [[self currentCursor] doubleValueAtIndex:index];
}

-(NSString *) stringValueForName:(NSString *) name{
    return [[self currentCursor] stringValueForName:name];
}

-(NSString *) stringValueAtIndex:(int) index{
    return [[self currentCursor] stringValueAtIndex:index];
}

-(NSDate *) dateValueForName:(NSString *) name{
    return [[self currentCursor] dateValueForName:name];
}

-(NSDate *) dateValueAtIndex:(int) index{
    return [[self currentCursor] dateValueAtIndex:index];
}

-(NSData *) dataValueForName:(NSString *) name{
    return [[self currentCursor] dataValueForName:name];
}

-(NSData * ) dataValueAtIndex:(int) index{
    return [[self currentCursor] dataValueAtIndex:index];
}

-(const char *) cStringValueForName:(NSString *) name{
    return [[self currentCursor] cStringValueForName:name];
}

-(const char *) cStringValueAtIndex:(int) index{
    return [[self currentCursor] cStringValueAtIndex:index];
}

-(id) valueForKey:(NSString *) key{
    return [[self currentCursor] valueForKey:key];
}

-(id) objectAtIndex:(NSUInteger) index{
    return [[self currentCursor] objectAtIndex:index];
}

-(void) toDataObject:(id) dataObject{
    [[self currentCursor] toDataObject:dataObject];
}

-(void) toDataObject:(id) dataObject forClass:(Class) dataObjectClass{
    [[self currentCursor] toDataObject:dataObject forClass:dataObjectClass];
}

-(NSArray *) dataObjects:(Class) dataObjectClass{
    return [[self currentCursor] dataObjects:dataObjectClass];
}


@end

@implementation VTSqlite

@synthesize path = _path;

-(id) initWithPath:(NSString *) path{
    if((self = [super init])){
        _path = [path retain];
        if(SQLITE_OK != sqlite3_open([path UTF8String], &_sqlite)){
            [self release];
            return nil;
        }
    }
    return self;
}

-(void) dealloc{
    if(_sqlite){
        for(VTSqliteCursor * cursor in _cursurs){
            [cursor close];
        }
        sqlite3_close(_sqlite);
    }
    for(VTSqliteCursor * cursor in _cursurs){
        [cursor setSqlite:nil];
    }
    [_cursurs release];
    [_path release];
    [super dealloc];
}

-(void) close{
    if(_sqlite){
        for(VTSqliteCursor * cursor in _cursurs){
            [cursor close];
        }
        sqlite3_close(_sqlite);
        _sqlite = NULL;
    }
    for(VTSqliteCursor * cursor in _cursurs){
        [cursor setSqlite:nil];
    }
    [_cursurs release];
    _cursurs = nil;
}

-(BOOL) rollback{
    return [self execture:@"rollback transaction" withData:nil];
}

-(BOOL) commit{
    return [self execture:@"commit transaction" withData:nil];
}

-(BOOL) beginTransaction{
    return [self execture:@"begin exclusive transaction" withData:nil];
}

-(BOOL) execture:(NSString *) sql withData:(id) data{
    
    if(_sqlite == NULL || sql == nil){
        return NO;
    }
    
    sqlite3_stmt * stmt;
    
    if(sqlite3_prepare_v2(_sqlite, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK){
        
        return NO;
    }
    
    VTSqliteStmtBindData(stmt,data,SQLITE_STATIC);
    
    int rs = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    return rs == SQLITE_OK || rs == SQLITE_ROW || rs == SQLITE_DONE;
    
}

-(void) exectureSqlFile:(NSString *) filePath{
    
    if(_sqlite == NULL){
        return;
    }
    
    FILE * f = fopen([filePath UTF8String], "r");
    
    char sbuf[102400];
    char * p;
    ssize_t len;
    int lines = 0;
    
    NSMutableData * line = [NSMutableData dataWithCapacity:1024];
    
    if(f){
        
        sqlite3_exec(_sqlite, "begin exclusive transaction", nil, nil, nil);
        
        while((len = fread(sbuf, 1, sizeof(sbuf), f)) >0){
            
            p = sbuf;
            
            while(len >=0){
                
                if(*p == '\0' || *p == '\n' || len ==0){
                    if([line length]){
                        
                        NSString * s = [[NSString alloc] initWithData:line encoding:NSUTF8StringEncoding];
                        
                        sqlite3_exec(_sqlite, [s UTF8String], nil, nil, nil);
                        
                        [s release];
                        
                        [line setLength:0];
                        
                        lines ++;
                        
                        if((lines % 100) ==0){
                            sqlite3_exec(_sqlite, "commit transaction", nil, nil, nil);
                            sqlite3_exec(_sqlite, "begin exclusive transaction", nil, nil, nil);
                        }
                    }
                }
                else{
                    [line appendBytes:p length:1];
                }
                
                if(len ==0){
                    break;
                }
                
                len -- ;
                p ++;
            }
            
        }
        
        sqlite3_exec(_sqlite, "commit transaction", nil, nil, nil);
        
        fclose(f);
    }
    
}

-(long long) lastInsertRowid{
    if(_sqlite){
        return sqlite3_last_insert_rowid(_sqlite);
    }
    return 0;
}

-(id<IVTSqliteCursor>) query:(NSString *) sql withData:(id) data{
    
    if(_sqlite == NULL || sql == nil){
        return nil;
    }
    
    sqlite3_stmt * stmt;
    
    if(sqlite3_prepare_v2(_sqlite, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK){
        return NO;
    }
    
    VTSqliteStmtBindData(stmt,data,SQLITE_TRANSIENT);
    
    VTSqliteCursor * cursor = [[VTSqliteCursor alloc] initWithStmt:stmt sqlite:self];
    
    if(_cursurs == nil){
        _cursurs = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    [_cursurs addObject:cursor];
    
    return [cursor autorelease];

}

-(NSInteger) errcode{
    if(_sqlite){
        return sqlite3_errcode(_sqlite);
    }
    return 0;
}

-(NSString *) errmsg{
    if(_sqlite){
        return [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite)];
    }
    return nil;
}

-(void) removeCursor:(VTSqliteCursor *) cursor{
    [cursor setSqlite:nil];
    [_cursurs removeObject:cursor];
}



@end

static void VTSqliteStmtBindData(sqlite3_stmt * stmt,id data,sqlite3_destructor_type type){
    
    int c = sqlite3_bind_parameter_count(stmt);
    
    for(int i=1;i<=c;i++){
        const char * name = sqlite3_bind_parameter_name(stmt, i);
        NSString * keyPath = nil;
        
        if(name){
            keyPath = [NSString stringWithCString:name + 1 encoding:NSUTF8StringEncoding];
        }
        else{
            keyPath = [NSString stringWithFormat:@"@%d",i-1];
        }
   
        id v = [data valueForKeyPath:keyPath];
        if(v == nil || [v isKindOfClass:[NSNull class]]){
            sqlite3_bind_null(stmt, i);
        }
        else if([v isKindOfClass:[NSData class]]){
            sqlite3_bind_blob(stmt, i, [v bytes], (int) [v length], type);
        }
        else if([v isKindOfClass:[NSDate class]]){
            sqlite3_bind_double(stmt, i, [v timeIntervalSince1970]);
        }
        else if([v isKindOfClass:[NSNumber class]]){
            
            if (strcmp([v objCType], @encode(BOOL)) == 0) {
                sqlite3_bind_int(stmt, i, ([v boolValue] ? 1 : 0));
            }
            else if (strcmp([v objCType], @encode(int)) == 0) {
                sqlite3_bind_int(stmt, i, [v intValue]);
            }
            else if (strcmp([v objCType], @encode(long)) == 0) {
                sqlite3_bind_int64(stmt, i, [v longValue]);
            }
            else if (strcmp([v objCType], @encode(long long)) == 0) {
                sqlite3_bind_int64(stmt, i, [v longLongValue]);
            }
            else if (strcmp([v objCType], @encode(unsigned long long)) == 0) {
                sqlite3_bind_int64(stmt, i, [v unsignedLongLongValue]);
            }
            else if (strcmp([v objCType], @encode(float)) == 0) {
                sqlite3_bind_double(stmt, i, [v floatValue]);
            }
            else if (strcmp([v objCType], @encode(double)) == 0) {
                sqlite3_bind_double(stmt, i, [v doubleValue]);
            }
            else {
                sqlite3_bind_text(stmt, i, [[v description] UTF8String], -1, type);
            }
        }
        else if([v isKindOfClass:[NSString class]]){
            sqlite3_bind_text(stmt, i, [v UTF8String], -1, type);
        }
        else {
            NSData * dataBytes = [[VTJSON encodeObject:v] dataUsingEncoding:NSUTF8StringEncoding];
            sqlite3_bind_blob(stmt, i, [dataBytes bytes],(int) [dataBytes length], type);
        }
        
    }
}

