//
//  VTLayoutContainer.h
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTLayout.h>

@interface VTLayoutContainer : NSObject

@property(nonatomic,retain) VTLayout * rootLayout;
@property(nonatomic,retain) IBOutletCollection(VTLayout) NSArray * layouts;

-(void) layout;

@end
