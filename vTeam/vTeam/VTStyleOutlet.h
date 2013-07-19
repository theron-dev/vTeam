//
//  VTStyleOutlet.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTStyleSheet;

@interface VTStyleOutlet : NSObject

@property(nonatomic,retain) NSString * status;
@property(nonatomic,assign) VTStyleSheet * styleSheet;
@property(nonatomic,retain) IBOutletCollection(NSObject) NSArray * views;
@property(nonatomic,retain) NSString * styleName;
@property(nonatomic,assign) NSInteger version;

-(void) applyStyle;

@end
