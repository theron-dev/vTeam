//
//  VTShell.h
//  vTeam
//
//  Created by zhang hailong on 13-4-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTUIContext.h>
#import <vTeam/IVTServiceContainer.h>

@interface VTShell : NSObject<IVTUIContext>

@property(nonatomic,readonly) id config;

-(id) initWithConfig:(id) config bundle:(NSBundle *) bundle;

-(id) rootViewController;

-(void) didReceiveMemoryWarning;

-(id<IVTServiceContainer>) addService:(Class) serviceClass;

@end
