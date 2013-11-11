//
//  IGridDraw.h
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol IGridDraw

-(void) drawToContext:(CGContextRef) ctx rect:(CGRect) rect;

@end
