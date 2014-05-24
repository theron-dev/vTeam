//
//  VTTableSource.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTTableSection.h>
#import <vTeam/VTController.h>

@interface VTTableSource : VTController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) IBOutletCollection(VTTableSection) NSArray * sections;

@end

@protocol VTTableSourceDelegate

@optional

-(void) vtTableSource:(VTTableSource *) tableSource tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath;

@end
