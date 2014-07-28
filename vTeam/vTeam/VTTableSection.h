//
//  VTTableSection.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTTableSection : NSObject

@property(nonatomic,retain) NSString * title;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,retain) IBOutlet UIView * footerView;
@property(nonatomic,retain) IBOutletCollection(UITableViewCell) NSArray * cells;
@property(nonatomic,assign) NSInteger tag;

@end
