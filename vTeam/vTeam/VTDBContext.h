//
//  VTDBContext.h
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDBObject.h>
#import <vTeam/VTSqlite.h>

@interface VTDBContext : NSObject

@property(nonatomic,retain) VTSqlite * db;

-(void) regDBObjectClass:(Class) dbObjectClass;

-(NSString *) insertObjectSQL:(Class) dbObjectClass;

-(NSString *) deleteObjectSQL:(Class) dbObjectClass;

-(NSString *) updateObjectSQL:(Class) dbObjectClass;

-(BOOL) insertObject:(VTDBObject *) dbObject;

-(BOOL) deleteObject:(VTDBObject *) dbObject;

-(BOOL) updateObject:(VTDBObject *) dbObject;

-(void) setObject:(VTDBObject *) dbObject;

-(void) removeObject:(VTDBObject *) dbObject;

-(void) removeObjects:(Class) dbObjectClass;

-(NSSet *) queryObjects:(Class) dbObjectClass;

-(id<IVTSqliteCursor>) query:(Class) dbObjectClass sql:(NSString *) sql data:(id) data;

-(id) valueForKey:(NSString *)key;

-(void) setValue:(id)value forKey:(NSString *)key;

@end
