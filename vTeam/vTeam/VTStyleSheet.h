//
//  VTStyleSheet.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTStyle.h>
#import <vTeam/VTStyleController.h>

@interface VTStyleSheet : NSObject

@property(nonatomic,assign) NSInteger version;
@property(nonatomic,retain) VTStyleController * styleController;

-(NSDictionary *) selectorStyle:(NSString *) styleName;

-(UIColor *) styleValueColor:(NSString *) value;

-(UIFont *) styleValueFont:(NSString *) value;

-(CGFloat) styleValueFloat:(NSString *) value;

-(UIImage *) styleValueImage:(NSString *) image;

-(void) didReceiveMemoryWarning;


@end
