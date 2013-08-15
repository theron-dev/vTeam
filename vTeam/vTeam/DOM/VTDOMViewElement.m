//
//  VTDOMViewElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMViewElement.h"

#import "VTDOMElement+Style.h"

@implementation VTDOMViewElement

@synthesize view = _view;

-(void) dealloc{
    [_view release];
    [super dealloc];
}

-(UIView *) view{
    if(_view == nil){
        NSString * view = [self stringValueForKey:@"view"];
        Class clazz = NSClassFromString(view);
        if(clazz == nil || ![clazz isSubclassOfClass:[UIView class]]){
            clazz = [UIView class];
        }
        self.view = [[[clazz alloc] initWithFrame:self.frame] autorelease];
    }
    return _view;
}

-(void) setView:(UIView *)view{
    if(_view != view){
        if([_view respondsToSelector:@selector(setElement:)]){
            [_view performSelector:@selector(setElement:) withObject:nil];
        }
        if([view respondsToSelector:@selector(setElement:)]){
            [view performSelector:@selector(setElement:) withObject:self];
        }
        [view retain];
        [_view release];
        _view = view;
    }
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    
    if([delegate isKindOfClass:[UIView class]]){
        NSString * viewtag = [self stringValueForKey:@"viewtag"];
        if(viewtag){
            self.view = [(UIView *)delegate viewWithTag:[viewtag intValue]];
        }
    }
}

@end
