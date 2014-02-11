//
//  UIImage+GaussianBlur.m
//  vTeam
//
//  Created by zhang hailong on 13-10-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIImage+GaussianBlur.h"

#import <CoreImage/CoreImage.h>

@implementation UIImage (GaussianBlur)

-(UIImage *)imageByGaussianBlurRadius:(CGFloat) radius{
    
    if(NSClassFromString(@"CIFilter")){
        
        CIFilter * filter = [CIFilter filterWithName:@"CIGaussianBlur"];
         
        if(filter){
            
            CIContext *context = [CIContext contextWithOptions:nil];
            
            CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
            
            [filter setValue:inputImage forKey:@"inputImage"];
            [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
            
            CIImage *result = [filter valueForKey:@"outputImage"];

            CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];

            UIImage * img = [UIImage imageWithCGImage:cgImage];
            
            CGImageRelease(cgImage);
            
            return img;
        }

    }
    
    return self;
}

@end
