//
//  VTHeapViewController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTHeapViewController : VTViewController

@property(nonatomic,readonly) UIViewController * topViewController;

-(void) popViewController:(BOOL) animated;

-(void) pushViewController:(UIViewController *) viewController animated:(BOOL)animated;


@end
