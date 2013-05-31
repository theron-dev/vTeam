//
//  VTFormButton.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTFormButton.h"

@implementation VTFormButton

@synthesize value = _value;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSString *)text{
    return [self titleForState:UIControlStateNormal];
}

-(void) setText:(NSString *)text{
    [self setTitle:text forState:UIControlStateNormal];
}

@end
