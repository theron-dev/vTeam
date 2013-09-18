//
//  DragLoadingView.m
//  Sports
//
//  Created by zhang hailong on 13-4-7.
//  Copyright (c) 2013年 sina.com. All rights reserved.
//

#import "VTDragLoadingView.h"

#import "VTAnimationView.h"

@implementation VTDragLoadingView

@synthesize directImageView = _directImageView;
@synthesize downTitleLabel = _downTitleLabel;
@synthesize upTitleLabel = _upTitleLabel;
@synthesize loadingView = _loadingView;
@synthesize loadingTitleLabel = _loadingTitleLabel;
@synthesize animating = _animating;
@synthesize direct = _direct;
@synthesize timeLabel = _timeLabel;
@synthesize leftTitleLabel = _leftTitleLabel;
@synthesize rightTitleLabel = _rightTitleLabel;
@synthesize offsetValue = _offsetValue;

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

- (void)dealloc {
    [_directImageView release];
    [_downTitleLabel release];
    [_upTitleLabel release];
    [_loadingView release];
    [_loadingTitleLabel release];
    [_timeLabel release];
    [_leftTitleLabel release];
    [_rightTitleLabel release];
    [super dealloc];
}

-(void) startAnimation{
    if(! _animating){
        
        [_loadingView setHidden:NO];
        
        if([_loadingView respondsToSelector:@selector(startAnimating)]){
            [_loadingView performSelector:@selector(startAnimating) withObject:nil];
        }
        [_directImageView setHidden:YES];
        [_downTitleLabel setHidden:YES];
        [_upTitleLabel setHidden:YES];
        [_leftTitleLabel setHidden:YES];
        [_rightTitleLabel setHidden:YES];
        [_loadingTitleLabel setHidden:NO];
        
        _animating = YES;
    }
}

-(void) stopAnimation{
    if( _animating ){
        if([_loadingView respondsToSelector:@selector(stopAnimating)]){
            [_loadingView performSelector:@selector(stopAnimating) withObject:nil];
        }
        [_loadingView setHidden:YES];
        [_loadingTitleLabel setHidden:YES];
        [_directImageView setHidden:NO];
        [_upTitleLabel setHidden:_direct != VTDragLoadingViewDirectUp];
        [_downTitleLabel setHidden:_direct != VTDragLoadingViewDirectDown];
        [_leftTitleLabel setHidden:_direct != VTDragLoadingViewDirectLeft];
        [_rightTitleLabel setHidden:_direct != VTDragLoadingViewDirectRight];
        
        _animating = NO;
    }
}

-(void) setDirect:(VTDragLoadingViewDirect)direct{
    _direct = direct;
    
    if( ! _animating){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
   
    switch (_direct) {
        case VTDragLoadingViewDirectDown:
        {
            [_directImageView setTransform:CGAffineTransformIdentity];
            [_upTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_downTitleLabel setHidden: _animating];
        }
            break;
        case VTDragLoadingViewDirectUp:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
            [_downTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_upTitleLabel setHidden: _animating];
        }
            break;
        case VTDragLoadingViewDirectLeft:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            [_downTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden:YES];
            [_upTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden: _animating];
        }
            break;
        case VTDragLoadingViewDirectRight:
        {
            [_directImageView setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
            [_downTitleLabel setHidden:YES];
            [_leftTitleLabel setHidden:YES];
            [_upTitleLabel setHidden:YES];
            [_rightTitleLabel setHidden: _animating];
        }
            break;
        default:
            break;
    }
   
    if( ! _animating){
    
        [UIView commitAnimations];
    }

}

-(void) setOffsetValue:(CGFloat)offsetValue{
    _offsetValue = offsetValue;
    if([_loadingView respondsToSelector:@selector(setOffsetValue:)]){
        [(VTDragLoadingView*)_loadingView setOffsetValue:offsetValue];
//        [_loadingView performSelector:@selector(setOffsetValue:) withObject:[NSNumber numberWithFloat:offsetValue]];
    }
}

@end
