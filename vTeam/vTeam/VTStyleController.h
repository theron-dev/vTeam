//
//  VTStyleSheetController.h
//  vTeam
//
//  Created by zhang hailong on 13-5-31.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTStyle.h>

@interface VTStyleController : UIViewController

@property(nonatomic,retain) IBOutletCollection(VTStyle) NSArray * styles;

@end
