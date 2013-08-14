//
//  VTDOMView.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMView.h"
#import "VTDOMElement+Layout.h"

@implementation VTDOMView

@synthesize element = _element;
@synthesize allowAutoLayout = _allowAutoLayout;

-(void) dealloc{
    [_element release];
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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
      
    [_element render:_element.frame context:ctx];
    
}



-(void) setElement:(VTDOMElement *)element{
    if(_element != element){
        [element retain];
        [_element release];
        _element = element;
        if(_allowAutoLayout){
            [_element layout:self.bounds.size];
        }
        [self setNeedsDisplay];
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(_allowAutoLayout){
        [_element layout:self.bounds.size];
    }
    [self setNeedsDisplay];
}


@end
