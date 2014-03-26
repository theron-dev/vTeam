//
//  UIColor+UIImage.m
//  vTeam
//
//  Created by zhang hailong on 14-3-24.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "UIColor+UIImage.h"

@implementation UIColor (UIImage)

-(UIImage *) imageWithSize:(CGSize) size{
    
    UIGraphicsBeginImageContext(size);
    
    [self set];
    [self setFill];
    
    CGContextFillRect(UIGraphicsGetCurrentContext()
                      , CGRectMake(0, 0, size.width, size.height));
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}

@end
