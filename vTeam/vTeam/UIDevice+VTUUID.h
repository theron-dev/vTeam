//
//  UIDevice+VTUUID.h
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (VTUUID)

@property(nonatomic,readonly,retain) NSString * vtUniqueIdentifier;
@property(nonatomic,readonly,retain) NSString * MACAddress;
@property(nonatomic,readonly,retain) NSString * WIFIAddress;
@property(nonatomic,readonly,assign,getter = isActiveWWAN) BOOL activeWWAN;
@property(nonatomic,readonly,assign,getter = isNetworkAvailable) BOOL networkAvailable;
@property(nonatomic,readonly,assign,getter = isActiveWLAN) BOOL activeWLAN;

@end
