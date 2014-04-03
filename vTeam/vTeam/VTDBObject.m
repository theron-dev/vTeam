//
//  VTDBObject.m
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDBObject.h"

#include <objc/runtime.h>

@implementation VTDBObject

@synthesize rowid = _rowid;

+(Class) tableClass{
    return [self class];
}

+(VTDBObjectIndex *) tableIndexs:(int *) length{
    return nil;
}

-(NSMutableDictionary *) toDictionary{
    
    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithCapacity:4];
    
    Class clazz = [[self class] tableClass];
    
    while(clazz && clazz != [NSObject class]){
        unsigned int propCount = 0;
        objc_property_t * prop =  class_copyPropertyList(clazz, &propCount);
        for(int i=0;i<propCount;i++){
            NSString * name = [NSString stringWithCString:property_getName(prop[i]) encoding:NSUTF8StringEncoding];
            [data setValue:[self valueForKey:name] forKey:name];
        }
        free(prop);
        clazz = class_getSuperclass(clazz);
    }
    
    return data;
}

@end
