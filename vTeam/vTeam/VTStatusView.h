//
//  VTStatusView.h
//  vTeam
//
//  Created by Zhang Hailong on 13-6-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTStatusViewItem : NSObject

@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutletCollection(UIView) NSArray * views;

@end

@interface VTStatusView : UIView

@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutletCollection(VTStatusViewItem) NSArray * statusItems;

-(void) setStatus:(NSString *)status animated:(BOOL) animated;

@end
