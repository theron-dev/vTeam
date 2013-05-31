//
//  VTZoomView.m
//  vTeam
//
//  Created by zhang hailong on 13-5-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTZoomView.h"

@implementation VTZoomView

@synthesize highlightedZoom = _highlightedZoom;

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
    [_actionName release];
    [_userInfo release];
    [_actionViews release];
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    if(highlighted){
        [self setTransform:CGAffineTransformMakeScale(1.0 + _highlightedZoom, 1.0 + _highlightedZoom)];
        [self.superview bringSubviewToFront:self];
    }
    else{
        [self setTransform:CGAffineTransformIdentity];
    }
    [UIView commitAnimations];
}

@end
