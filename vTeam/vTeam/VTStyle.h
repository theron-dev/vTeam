//
//  VTStyle.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTStyleSheet;

@interface VTStyle : NSObject

@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * key;
@property(nonatomic,retain) id value;
@property(nonatomic,retain) NSString * imageValue;
@property(nonatomic,retain) NSString * fontValue;
@property(nonatomic,retain) NSString * edgeValue;

@end
