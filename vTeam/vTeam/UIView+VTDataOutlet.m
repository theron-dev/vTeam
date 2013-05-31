//
//  UIView+VTDataOutlet.m
//  vTeam
//
//  Created by zhang hailong on 13-5-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIView+VTDataOutlet.h"

@implementation UIView (VTDataOutlet)

-(void) setVisable:(BOOL)visable{
    [self setHidden:!visable];
}

-(BOOL) isVisable{
    return ![self isHidden];
}

@end
