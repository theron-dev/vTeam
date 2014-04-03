//
//  VTDBObject.h
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct _VTDBObjectIndex{
    char name[NAME_MAX];
    char desc;
} VTDBObjectIndex;

@interface VTDBObject : NSObject

@property(nonatomic,assign) long long rowid;

+(Class) tableClass;

+(VTDBObjectIndex *) tableIndexs:(int *) length;

-(NSMutableDictionary *) toDictionary;

@end
