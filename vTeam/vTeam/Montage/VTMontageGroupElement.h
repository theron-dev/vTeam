//
//  VTMontageGroupElement.h
//  vTeam
//
//  Created by zhang hailong on 13-9-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTMontageGroupElement : VTMontageElement

@property(nonatomic,retain) IBOutletCollection(VTMontageElement) NSArray * elements;


@end
