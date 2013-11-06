//
//  VTActionView.h
//  vTeam
//
//  Created by zhang hailong on 13-11-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTAction.h>

@interface VTActionView : UIControl<IVTAction>

@property(nonatomic,retain) UIColor * maskColor;
    
@end
