//
//  VTDBDataContext.h
//  vTeam
//
//  Created by zhang hailong on 14-4-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTDBContext.h>

#import <vTeam/VTDBDataObject.h>

extern NSString * VTDBDataObjectChangedNotification;
extern NSString * VTDBDataObjectSetKey;

@interface VTDBDataContext : VTDBContext

-(id) dataObjectForKey:(NSString *) key tableClass:(Class) tableClass;

-(id) dataObjectForCacheKey:(NSString *) key tableClass:(Class) tableClass;

-(void) setDataObject:(VTDBDataObject *) dataObject;

-(BOOL) fillDataObject:(VTDBDataObject *) dataObject;

-(NSSet *) dataObjects:(Class) tableClass;

-(NSArray *) dataKeys:(Class) tableClass query:(NSString *) query data:(id) data;

-(void) beginUpdate;

-(void) endUpdate;

@end
