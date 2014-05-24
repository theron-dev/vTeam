//
//  VTDOMViewElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMViewElement.h"

#import "VTDOMElement+Style.h"
#import "VTDOMElement+Frame.h"
#import "VTDOMElement+Render.h"

#import "UIView+VTDOMElement.h"

@implementation VTDOMViewElement

@synthesize view = _view;

-(void) dealloc{
    [_view release];
    [super dealloc];
}

-(void) setView:(UIView *)view{
    if(_view != view){
        [view retain];
        [_view release];
        _view = view;
        if([_view respondsToSelector:@selector(setElement:)]){
            [_view performSelector:@selector(setElement:) withObject:self];
        }
    }
}

-(Class) viewClass{
    NSString * view = [self stringValueForKey:@"viewClass"];
    Class clazz = NSClassFromString(view);
    if(clazz == nil || ![clazz isSubclassOfClass:[UIView class]]){
        clazz = [UIView class];
    }
    return clazz;
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    
    if([delegate isKindOfClass:[UIView class]]){
        if([delegate respondsToSelector:@selector(vtDOMElementView:viewClass:)]){
            self.view = [delegate vtDOMElementView:self viewClass:[self viewClass]];
        }
        if([delegate respondsToSelector:@selector(vtDOMElement:addView:frame:)]){
            [delegate vtDOMElement:self.parentElement addView:self.view frame:self.frame];
        }
    }
    else if([self isViewLoaded]){
        [self.view removeFromSuperview];
        self.view = nil;
    }
}

-(void) elementDidFrameChanged:(VTDOMElement *) element{
    if([self isViewLoaded] && [self.delegate respondsToSelector:@selector(vtDOMElement:convertRect:)]){
        self.view.frame = [self.delegate vtDOMElement:self.parentElement convertRect:self.frame];
    }
}


-(NSString *) actionName{
    return [self attributeValueForKey:@"action-name"];
}

-(void) setActionName:(NSString *)actionName{
    [self setAttributeValue:actionName forKey:@"action-name"];
}

-(id) userInfo{
    return [self attributeValueForKey:@"user-info"];
}

-(void) setUserInfo:(id)userInfo{
    [self setAttributeValue:userInfo forKey:@"user-info"];
}

-(NSArray *) actionViews{
    return nil;
}

-(void) setActionViews:(NSArray *)actionViews{
    
}

-(BOOL) isViewLoaded{
    return _view != nil;
}

-(void) unbindDelegate:(id)delegate{
    if(self.delegate == delegate){
        self.delegate = nil;
    }
}

-(void) bindDelegate:(id)delegate{
    self.delegate = delegate;
}

-(void) elementDidAppera:(VTDOMElement *) element{
    
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
}

-(void) setAttributeValue:(NSString *)value forKey:(NSString *)key{
    [super setAttributeValue:value forKey:key];
    
    if([self isViewLoaded]){
        [self.view element:self attributeChangedValue:value forKey:key];
    }
    
}

-(void) setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    
    if([self isViewLoaded]){
        [self.view element:self valueChangedValue:value forKey:key];
    }
}

@end
