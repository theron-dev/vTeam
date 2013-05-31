//
//  UIView+Search.h
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Search)

-(NSArray *) searchViewForClass:(Class) clazz;

-(NSArray *) searchViewForProtocol:(Protocol *) protocol;

@end
