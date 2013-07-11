//
//  UIButton+VTStyle.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIButton+VTStyle.h"

@implementation UIButton (VTStyle)

-(UIImage *) backgroundImage{
    return [self backgroundImageForState:UIControlStateNormal];
}

-(void) setBackgroundImage:(UIImage *)backgroundImage{
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

-(UIImage *) backgroundImageHighlighted{
    return [self backgroundImageForState:UIControlStateHighlighted];
}

-(void) setBackgroundImageHighlighted:(UIImage *)backgroundImageHighlighted{
    [self setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
}

-(UIImage *) backgroundImageDisabled{
    return [self backgroundImageForState:UIControlStateDisabled];
}

-(void) setBackgroundImageDisabled:(UIImage *)backgroundImageDisabled{
    [self setBackgroundImage:backgroundImageDisabled forState:UIControlStateDisabled];
}

-(UIImage *) backgroundImageSelected{
    return [self backgroundImageForState:UIControlStateSelected];
}

-(void) setBackgroundImageSelected:(UIImage *)backgroundImageSelected{
    [self setBackgroundImage:backgroundImageSelected forState:UIControlStateSelected];
}

-(NSString *) title{
    return [self titleForState:UIControlStateNormal];
}

-(void) setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

-(UIColor *) textColor{
    return [self titleColorForState:UIControlStateNormal];
}

-(void) setTextColor:(UIColor *)textColor{
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

-(UIColor *) textColorHighlighted{
    return [self titleColorForState:UIControlStateHighlighted];
}

-(void) setTextColorHighlighted:(UIColor *)textColorHighlighted{
    [self setTitleColor:textColorHighlighted forState:UIControlStateHighlighted];
}

-(UIColor *) textColorDisabled{
    return [self titleColorForState:UIControlStateDisabled];
}

-(void) setTextColorDisabled:(UIColor *)textColorDisabled{
    [self setTitleColor:textColorDisabled forState:UIControlStateDisabled];
}

-(UIColor *) textColorSelected{
    return [self titleColorForState:UIControlStateSelected];
}

-(void) setTextColorSelected:(UIColor *)textColorSelected{
    [self setTitleColor:textColorSelected forState:UIControlStateSelected];
}

-(UIColor *) titleColor{
    return [self titleColorForState:UIControlStateNormal];
}

-(void) setTitleColor:(UIColor *)textColor{
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

-(UIColor *) titleColorHighlighted{
    return [self titleColorForState:UIControlStateHighlighted];
}

-(void) setTitleColorHighlighted:(UIColor *)textColorHighlighted{
    [self setTitleColor:textColorHighlighted forState:UIControlStateHighlighted];
}

-(UIColor *) titleColorDisabled{
    return [self titleColorForState:UIControlStateDisabled];
}

-(void) setTitleColorDisabled:(UIColor *)textColorDisabled{
    [self setTitleColor:textColorDisabled forState:UIControlStateDisabled];
}

-(UIColor *) titleColorSelected{
    return [self titleColorForState:UIControlStateSelected];
}

-(void) setTitleColorSelected:(UIColor *)textColorSelected{
    [self setTitleColor:textColorSelected forState:UIControlStateSelected];
}

-(UIImage *) image{
    return [self imageForState:UIControlStateNormal];
}

-(void) setImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}

-(UIImage *) imageHighlighted{
    return [self imageForState:UIControlStateHighlighted];
}

-(void) setImageHighlighted:(UIImage *)imageHighlighted{
    [self setImage:imageHighlighted forState:UIControlStateHighlighted];
}

-(UIImage *) imageDisabled{
    return [self imageForState:UIControlStateDisabled];
}

-(void) setImageDisabled:(UIImage *)imageDisabled{
    [self setImage:imageDisabled forState:UIControlStateDisabled];
}

-(UIImage *) imageSelected{
    return [self imageForState:UIControlStateSelected];
}

-(void) setImageSelected:(UIImage *)imageSelected{
    [self setImage:imageSelected forState:UIControlStateSelected];
}

@end
