//
//  VTDOMImageElement.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMElement.h>

#import <vTeam/IVTImageTask.h>

@interface VTDOMImageElement : VTDOMElement<IVTLocalImageTask>

@property(nonatomic,retain) UIImage * image;

@end
