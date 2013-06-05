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

@end
