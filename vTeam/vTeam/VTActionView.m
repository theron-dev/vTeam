//
//  VTActionView.m
//  vTeam
//
//  Created by zhang hailong on 13-11-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTActionView.h"

#import <QuartzCore/QuartzCore.h>

@interface VTActionView()
    
@property(nonatomic,retain) CALayer * maskLayer;

@end

@implementation VTActionView

@synthesize maskLayer = _maskLayer;
@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;
    
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
    
-(void) dealloc{
    [_actionViews release];
    [_actionName release];
    [_userInfo release];
    [_maskLayer release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
    
-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        if(_maskLayer == nil){
            _maskLayer =[[CALayer alloc] init];
        }
        if(_maskColor){
            _maskLayer.backgroundColor = [_maskColor CGColor];
        }
        else{
            _maskLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
        }
        _maskLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_maskLayer];
    }
    else{
        [_maskLayer removeFromSuperlayer];
    }
}


@end
