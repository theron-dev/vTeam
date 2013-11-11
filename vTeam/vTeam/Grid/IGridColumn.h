//
//  IGridColumn.h
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vTeam/IGridCell.h>

@protocol IGridColumn <IGridCell>

@property(nonatomic,assign,getter = isHidden) BOOL hidden;

-(id<IGridCell>) newDataCell:(id) data;

@end
