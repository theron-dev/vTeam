//
//  VTTableDataController.h
//  vTeam
//
//  Created by Zhang Hailong on 13-7-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTTableDataController : VTDataController<UITableViewDataSource,UITableViewDelegate,VTTableViewDelegate,VTTableViewCellDelegate>

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) NSString * itemViewNib;
@property(nonatomic,retain) NSBundle * itemViewBundle;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * topLoadingView;
@property(nonatomic,retain) IBOutlet VTDragLoadingView * bottomLoadingView;
@property(nonatomic,retain) IBOutlet UIView * notFoundDataView;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * autoHiddenViews;
@property(nonatomic,retain) IBOutletCollection(UITableViewCell) NSArray * headerCells;
@property(nonatomic,retain) IBOutletCollection(UITableViewCell) NSArray * footerCells;

@end

@protocol VTTableDataControllerDelegate <VTDataControllerDelegate>

@optional

-(void) vtTableDataController:(VTTableDataController *) dataController cell:(VTTableViewCell *) cell doAction:(id<IVTAction>) action;

@end

