//
//  VTBehaviorTransactionTask.h
//  vTeam
//
//  Created by zhang hailong on 13-8-1.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@protocol IVTBehaviorTransactionTask <IVTTask>

-(void) onBehaviorDBContext:(VTDBContext *) dbContext;

@end

@interface VTBehaviorTransactionTask : VTTask<IVTBehaviorTransactionTask>

+(id) behaviorTransactionTask:(void (^)(VTDBContext * dbContext)) onBehaviorDBContext;

+(id) behaviorCleanupTask:(long long) maxRowid tableClass:(Class) tableClass;

@end
