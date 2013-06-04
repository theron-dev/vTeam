//
//  VTDBContext.h
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDBObject.h>

@interface VTDBContext : NSObject

-(id) initWithPath:(NSString * ) dbPath;

-(void) regDBObjectClass:(Class) dbObjectClass;

-(void) insertObject:(VTDBObject *) dbObject;

-(void) deleteObject:(VTDBObject *) dbObject;

-(void) updateObject:(VTDBObject *) dbObject;

@end
