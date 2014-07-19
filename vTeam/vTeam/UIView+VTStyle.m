//
//  UIView+VTStyle.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+VTStyle.h"
#import <CoreImage/CoreImage.h>

@implementation UIView (VTStyle)

-(CGFloat) cornerRadius{
    return self.layer.cornerRadius;
}

-(void) setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(UIColor *) shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

-(void) setShadowColor:(UIColor *)shadowColor{
    self.layer.shadowColor = [shadowColor CGColor];
}

-(float) shadowOpacity{
    return self.layer.shadowOpacity;
}

-(void) setShadowOpacity:(float)shadowOpacity{
    self.layer.shadowOpacity = shadowOpacity;
}

-(CGSize) shadowOffset{
    return self.layer.shadowOffset;
}

-(void) setShadowOffset:(CGSize)shadowOffset{
    self.layer.shadowOffset = shadowOffset;
}

-(CGFloat) shadowRadius{
    return self.layer.shadowRadius;
}

-(void) setShadowRadius:(CGFloat)shadowRadius{
    self.layer.shadowRadius = shadowRadius;
}

-(void) setBackgroundImage:(UIImage *)backgroundImage{
    [self setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
}

-(UIImage *) backgroundImage{
    return nil;
}

-(float) borderWidth{
    return self.layer.borderWidth;
}

-(void) setBorderWidth:(float)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(UIColor *) borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void) setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = [borderColor CGColor];
}

-(NSString *) fontName{
    if([self respondsToSelector:@selector(font)]){
        return [[(UILabel *)self font] fontName];
    }
    return nil;
}

-(void) setFontName:(NSString *)fontName{
    if([self respondsToSelector:@selector(font)]){
        UIFont * f = [(UILabel *)self font];
        if(f && fontName){
            f = [UIFont fontWithName:fontName size:f.pointSize];
        }
        if([self respondsToSelector:@selector(setFont:)]){
            [(UILabel *)self setFont:f];
        }
    }
}

@end
