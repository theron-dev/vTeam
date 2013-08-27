//
//  IVTController.h
//  vTeam
//
//  Created by zhang hailong on 13-8-27.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IVTUIContext;

@protocol IVTController <NSObject>

@property(nonatomic,assign) id<IVTUIContext> context;
@property(nonatomic,assign) IBOutlet id delegate;

@end
