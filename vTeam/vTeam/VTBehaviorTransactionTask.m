//
//  VTBehaviorTransactionTask.m
//  vTeam
//
//  Created by zhang hailong on 13-8-1.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTBehaviorTransactionTask.h"

@interface VTBehaviorTransactionTaskImpl : VTBehaviorTransactionTask{
    void (^_onBehaviorDBContext)(VTDBContext * dbContext);
}


-(id) initWithOnBehaviorDBContext:(void (^)(VTDBContext * dbContext)) onBehaviorDBContext;

@end

@implementation VTBehaviorTransactionTaskImpl

-(id) initWithOnBehaviorDBContext:(void (^)(VTDBContext * dbContext)) onBehaviorDBContext{
    if((self = [super init])){
        _onBehaviorDBContext = [onBehaviorDBContext copy];
    }
    return self;
}

-(void) onBehaviorDBContext:(VTDBContext *) dbContext{
    if(_onBehaviorDBContext){
        _onBehaviorDBContext(dbContext);
    }
}

-(void) dealloc{
    [_onBehaviorDBContext release];
    [super dealloc];
}

@end

@implementation VTBehaviorTransactionTask


+(id) behaviorTransactionTask:(void (^)(VTDBContext * dbContext)) onBehaviorDBContext{
    VTBehaviorTransactionTaskImpl * task = [[VTBehaviorTransactionTaskImpl alloc] initWithOnBehaviorDBContext:onBehaviorDBContext];
    return [task autorelease];
}

+(id) behaviorCleanupTask:(long long) maxRowid tableClass:(Class) tableClass{
    return [self behaviorTransactionTask:^(VTDBContext *dbContext) {
        [dbContext.db execture:[NSString stringWithFormat:@"DELETE FROM [%@] WHERE [rowid]<=%lld",NSStringFromClass(tableClass),maxRowid] withData:nil];
    }];
}

-(void) onBehaviorDBContext:(VTDBContext *) dbContext{
    
}

@end
