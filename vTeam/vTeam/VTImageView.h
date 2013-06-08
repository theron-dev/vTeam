//
//  VTImageView.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTImageTask.h>

@interface VTImageView : UIImageView<IVTLocalImageTask>

@property(nonatomic,retain) UIImage * defaultImage;
@property(nonatomic,retain) NSString * imageMode;

@end
