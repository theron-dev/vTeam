//
//  VTStyleContainer.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTStyleOutlet.h>
#import <vTeam/VTStyleSheet.h>

@interface VTStyleOutletContainer : NSObject

@property(nonatomic,retain) IBOutletCollection(VTStyleOutlet) NSArray * styles;

-(void) setStyleSheet:(VTStyleSheet *) styleSheet;

@end
