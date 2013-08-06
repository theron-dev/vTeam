//
//  VTSqlite.h
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IVTSqliteCursor <NSObject>

@property(nonatomic,readonly,getter = isClosed) BOOL closed;

-(void) close;

-(BOOL) reset;

-(BOOL) next;

-(int) count;

-(int) columnCount;

-(int) columnIndexForName:(NSString *) name;

-(NSString *) columnNameAtIndex:(int) index;

-(int) intValueForName:(NSString *) name;

-(int) intValueAtIndex:(int) index;

-(long) longValueForName:(NSString *) name;

-(long) longValueAtIndex:(int) index;

-(long long) longLongValueForName:(NSString *) name;

-(long long) longLongValueAtIndex:(int) index;

-(BOOL) boolValueForName:(NSString *) name;

-(BOOL) boolValueAtIndex:(int) index;

-(double) doubleValueForName:(NSString *) name;

-(double) doubleValueAtIndex:(int) index;

-(NSString *) stringValueForName:(NSString *) name;

-(NSString *) stringValueAtIndex:(int) index;

-(NSDate *) dateValueForName:(NSString *) name;

-(NSDate *) dateValueAtIndex:(int) index;

-(NSData *) dataValueForName:(NSString *) name;

-(NSData * ) dataValueAtIndex:(int) index;

-(const char *) cStringValueForName:(NSString *) name;

-(const char *) cStringValueAtIndex:(int) index;

-(id) valueForKey:(NSString *) key;

-(id) objectAtIndex:(NSUInteger) index;

-(void) toDataObject:(id) dataObject;

-(void) toDataObject:(id) dataObject forClass:(Class) dataObjectClass;

-(NSArray *) dataObjects:(Class) dataObjectClass;


@end

@interface VTSqliteUnionCursor : NSObject<IVTSqliteCursor>

@property(nonatomic,readonly,retain) NSArray * cursors;

-(id) initWithCursors:(NSArray *) cursors;

@end

@interface VTSqlite : NSObject

@property(nonatomic,readonly) NSString * path;

-(id) initWithPath:(NSString *) path;

-(void) close;

-(BOOL) rollback;

-(BOOL) commit;

-(BOOL) beginTransaction;

-(BOOL) execture:(NSString *) sql withData:(id) data;

-(void) exectureSqlFile:(NSString *) filePath;

-(id<IVTSqliteCursor>) query:(NSString *) sql withData:(id) data;

-(NSInteger) errcode;

-(NSString *) errmsg;

-(long long) lastInsertRowid;

@end
