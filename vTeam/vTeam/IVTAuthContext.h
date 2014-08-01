//
//  IVTAuthContext.h
//  vTeam
//
//  Created by zhang hailong on 13-12-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTContext.h>

@protocol IVTAuthContext <IVTContext>

@property(nonatomic,retain) id uid;
@property(nonatomic,retain) NSString * token;
@property(nonatomic,readonly) NSString * domain;

-(void) setAuthValue:(id) value forKey:(NSString *)key;

-(id) authValueForKey:(NSString *) key;

-(NSArray *) authKeys;

@end
