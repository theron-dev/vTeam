//
//  VTTableSource.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTTableSection.h>

@interface VTTableSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutletCollection(VTTableSection) NSArray * sections;

@end
