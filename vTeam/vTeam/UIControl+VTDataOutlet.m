//
//  UIControl+VTDataOutlet.m
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIControl+VTDataOutlet.h"

@implementation UIControl (VTDataOutlet)

-(BOOL) isDisabled{
    return ![self isEnabled];
}

-(void) setDisabled:(BOOL)disabled{
    [self setEnabled:!disabled];
}

@end
