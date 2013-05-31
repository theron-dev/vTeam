//
//  VTViewLayout.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTLayout.h>

@interface VTViewLayout : VTLayout

@property(nonatomic,retain) IBOutletCollection(VTLayoutData) NSArray * layoutDatas;
@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,assign) CGSize size;
@property(nonatomic,assign) UIEdgeInsets padding;

-(void) setNeedsLayout;

-(void) doLayout;

@end
