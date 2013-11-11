//
//  GridScrollView.h
//  vTeam
//
//  Created by zhang hailong on 13-4-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTScrollView.h>
#import <vTeam/IGridView.h>

@interface GridScrollView : VTScrollView<IGridView>

@property(nonatomic,retain) UIView<IGridView> * gridView;
@property(nonatomic,retain) UIView<IGridView> * apposeView;

@end
