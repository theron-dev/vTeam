//
//  VTDOMTableElement.h
//  vTeam
//
//  Created by zhang hailong on 14-2-23.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTDOMTableElement : VTDOMViewElement<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,readonly) UITableView * tableView;

-(VTDOMElement *) elementByIndexPath:(NSIndexPath *) indexPath;

@end
