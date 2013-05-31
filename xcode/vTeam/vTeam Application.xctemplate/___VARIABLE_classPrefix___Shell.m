/**
 *  ___VARIABLE_classPrefix___Shell.m
 *  ___PROJECTNAME___
 *
 *  Created by ___FULLUSERNAME___ on ___DATE___.
 *  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 */

#import "___VARIABLE_classPrefix___Shell.h"


@implementation ___VARIABLE_classPrefix___Shell

-(id) init{
    if((self = [super initWithConfig:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cfg" ofType:@"plist"]] bundle:nil])){
        
    }
    return self;
}

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    NSLog(@"%@",NSHomeDirectory());
    
    [_window setRootViewController:self.rootViewController];
    [_window makeKeyAndVisible];
    
    return YES;
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [self didReceiveMemoryWarning];
}

-(void) applicationDidEnterBackground:(UIApplication *)application{
    [self didReceiveMemoryWarning];
}

@end
