//
//  VTTableDataController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

#import <vTeam/VTTableViewCell.h>

@interface VTTableDataController : VTDataController<UITableViewDataSource,UITableViewDelegate,VTTableViewCellDelegate>

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) NSString * itemViewNib;
@property(nonatomic,retain) NSString * itemViewClass;
@property(nonatomic,retain) NSBundle * itemViewBundle;

@end

@protocol VTTableDataControllerDelegate <VTDataControllerDelegate>

@optional

-(void) vtTableDataController:(VTTableDataController *) dataController itemViewController:(VTTableViewCell *) cell doAction:(id<IVTAction>) action;

@end