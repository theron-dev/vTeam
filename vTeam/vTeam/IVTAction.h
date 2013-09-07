//
//  IVTAction.h
//  vTeam
//
//  Created by zhang hailong on 13-5-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IVTAction <NSObject>

@property(nonatomic,retain) NSString * actionName;
@property(nonatomic,retain) id userInfo;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * actionViews;

@end
