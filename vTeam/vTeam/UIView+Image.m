//
//  UIView+Image.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIView+Image.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Image)

-(UIImage *) toImage{
    
    CGSize size = self.bounds.size;
    
    UIGraphicsBeginImageContext(size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
