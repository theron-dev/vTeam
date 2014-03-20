//
//  UIActivityIndicatorView+VTDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 14-2-19.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "UIActivityIndicatorView+VTDOMElement.h"

@implementation UIActivityIndicatorView (VTDOMElement)

-(id) initWithFrame:(CGRect)frame{
    return [self initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void) setElement:(VTDOMElement *)element{
    [super setElement:element];
    if(![self isHidden]){
        [self startAnimating];
    }
}

@end
