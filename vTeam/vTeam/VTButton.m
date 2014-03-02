//
//  VTButton.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTButton.h"

#import "UIView+VTDOMElement.h"
#import "VTDOMElement+Style.h"

@interface VTButton() {
    NSMutableDictionary * _backgroundColorForState;
}

@end

@implementation VTButton


@synthesize actionName = _actionName;
@synthesize userInfo = _userInfo;
@synthesize actionViews = _actionViews;

-(void) dealloc{
    [_actionViews release];
    [_actionName release];
    [_userInfo release];
    [_backgroundColorForState release];
    [super dealloc];
}

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

-(void) _refreshBackgroundColorForState{
    
    UIColor * color = nil;
    
    if( ! [self isEnabled] ){
        color = [self backgroundColorForState:UIControlStateDisabled];
    }
    else if([self isHighlighted]){
        color = [self backgroundColorForState:UIControlStateHighlighted];
    }
    else if([self isSelected]){
        color = [self backgroundColorForState:UIControlStateSelected];
    }
    
    if(color == nil){
        color = [self backgroundColorForState:UIControlStateNormal];
    }
    
    [super setBackgroundColor:color];
}

-(void) setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self _refreshBackgroundColorForState];
}

-(void) setSelected:(BOOL)selected{
    [super setSelected: selected];
    
    [self _refreshBackgroundColorForState];
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    [self _refreshBackgroundColorForState];
}


-(UIColor *) backgroundColor{
    return [self backgroundColorForState:UIControlStateNormal];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor{
    [self setBackgroundColor:backgroundColor forState:UIControlStateNormal];
}

-(UIColor *) backgroundColorDisabled{
    return [self backgroundColorForState:UIControlStateDisabled];
}

-(void) setBackgroundColorDisabled:(UIColor *)backgroundColorDisabled{
    [self setBackgroundColor:backgroundColorDisabled forState:UIControlStateDisabled];
}

-(UIColor *) backgroundColorHighlighted{
    return [self backgroundColorForState:UIControlStateHighlighted];
}

-(void) setBackgroundColorHighlighted:(UIColor *)backgroundColorHighlighted{
    [self setBackgroundColor:backgroundColorHighlighted forState:UIControlStateHighlighted];
}

-(UIColor *) backgroundColorSelected{
    return [self backgroundColorForState:UIControlStateSelected];
}

-(void) setBackgroundColorSelected:(UIColor *)backgroundColorSelected{
    [self setBackgroundColor:backgroundColorSelected forState:UIControlStateSelected];
}

-(UIColor *) backgroundColorForState:(UIControlState)state{
    return [_backgroundColorForState objectForKey:[NSNumber numberWithInt:state]];
}

-(void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    if(_backgroundColorForState == nil){
        _backgroundColorForState = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    if(backgroundColor){
        [_backgroundColorForState setObject:backgroundColor forKey:[NSNumber numberWithInt:state]];
    }
    else{
        [_backgroundColorForState removeObjectForKey:[NSNumber numberWithInt:state]];
    }
    
    [self _refreshBackgroundColorForState];
}

-(void) setElement:(VTDOMElement *)element{
    [super setElement: element];
    
    [self setBackgroundColor:[element colorValueForKey:@"background-color"] forState:UIControlStateNormal];
    [self setBackgroundColor:[element colorValueForKey:@"background-color-highlighted"] forState:UIControlStateHighlighted];
    [self setBackgroundColor:[element colorValueForKey:@"background-color-disabled"] forState:UIControlStateDisabled];
    [self setBackgroundColor:[element colorValueForKey:@"background-color-selected"] forState:UIControlStateSelected];
    
}

@end
