//
//  IGridView.h
//  vTeam
//
//  Created by zhang hailong on 13-4-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Grid.h"


@protocol IGridView <NSObject>

@property(nonatomic,retain) Grid * grid;

@end
