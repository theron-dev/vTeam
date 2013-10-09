//
//  UIImage+GaussianBlur.h
//  vTeam
//
//  Created by zhang hailong on 13-10-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlur)

-(UIImage *) imageByGaussianBlurRadius:(CGFloat) radius;

@end
