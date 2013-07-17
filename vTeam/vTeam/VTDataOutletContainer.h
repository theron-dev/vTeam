//
//  VTDataOutletContainer.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDataOutlet.h>

@interface VTDataOutletContainer : NSObject

@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutletCollection(VTDataOutlet) NSArray * dataOutlets;

-(void) applyDataOutlet:(id) data;

@end
