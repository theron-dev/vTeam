//
//  VTTableView.h
//  vTeam
//
//  Created by Zhang Hailong on 13-7-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTTableView : UITableView

@end

@protocol VTTableViewDelegate <UITableViewDelegate>

@optional

-(void) tableView:(UITableView *) tableView didContentOffsetChanged:(CGPoint) contentOffset;

-(void) tableView:(UITableView *) tableView willMoveToWindow:(UIWindow *) window;

-(void) tableView:(UITableView *) tableView didMoveToWindow:(UIWindow *) window;

@end