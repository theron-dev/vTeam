//
//  VTDBObject.m
//  vTeam
//
//  Created by zhang hailong on 13-6-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDBObject.h"

@implementation VTDBObject

@synthesize rowid = _rowid;

+(Class) tableClass{
    return [self class];
}

+(VTDBObjectIndex *) tableIndexs:(int *) length{
    return nil;
}

-(oneway void) release{
    [self willRelease:[self retainCount]];
    [super release];
}

-(void) willRelease:(NSUInteger) retainCount{
    
}

@end
