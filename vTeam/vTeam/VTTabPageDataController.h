//
//  VTTabPageDataController.h
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTTabPageDataController : VTTabDataController<VTScrollViewDelegate>

@property(nonatomic,retain) IBOutlet UIScrollView * pageContentView;
@property(nonatomic,retain) IBOutlet UIView * tabBackgroundView;
@property(nonatomic,assign) CGFloat leftSpaceWidth;
@property(nonatomic,assign) CGFloat rightSpaceWidth;

-(void) scrollToTabButton:(NSUInteger) index;

@end
