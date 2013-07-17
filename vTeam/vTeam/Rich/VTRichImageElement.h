//
//  VTRichImageElement.h
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTRich.h>

@interface VTRichImageElement : VTRichElement<IVTRichDrawElement>

@property(nonatomic,retain) UIImage * image;
@property(nonatomic,assign) CGSize size;

@end
