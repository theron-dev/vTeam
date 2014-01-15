//
//  IGridValue.h
//  vTeam
//
//  Created by zhang hailong on 14-1-15.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IGridValue <NSObject>

-(id) valueForKey:(NSString *) key;

-(void) setValue:(id) value forKey:(NSString *) key;

@end
