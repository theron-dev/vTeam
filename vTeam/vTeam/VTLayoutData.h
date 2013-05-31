//
//  VTLayoutData.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTLayoutData : NSObject

@property(nonatomic,retain) IBOutlet UIView * view;
@property(nonatomic,retain) id width;
@property(nonatomic,retain) id height;
@property(nonatomic,retain) id left;
@property(nonatomic,retain) id right;
@property(nonatomic,retain) id top;
@property(nonatomic,retain) id bottom;
@property(nonatomic,assign) BOOL widthToFit;
@property(nonatomic,assign) BOOL heightToFit;

-(CGRect) frameOfSize:(CGSize) size;

-(CGFloat) value:(id) value ofBase:(CGFloat) baseValue;

@end
