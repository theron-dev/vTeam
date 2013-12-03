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
    if([_view respondsToSelector:@selector(setElement:)]){
        [_view performSelector:@selector(setElement:) withObject:nil];
    }
    [_view release];
    [super dealloc];
}

-(void) setView:(UIView *)view{
    if(_view != view){
        if([_view respondsToSelector:@selector(setElement:)]){
            [_view performSelector:@selector(setElement:) withObject:nil];
        }
        [view retain];
        [_view release];
        _view = view;
        if([_view respondsToSelector:@selector(setElement:)]){
            [_view performSelector:@selector(setElement:) withObject:self];
        }
    }
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    
    if([delegate isKindOfClass:[UIView class]]){
        if([delegate respondsToSelector:@selector(vtDOMElementView:viewClass:)]){
            NSString * view = [self stringValueForKey:@"viewClass"];
            Class clazz = NSClassFromString(view);
            if(clazz == nil || ![clazz isSubclassOfClass:[UIView class]]){
                clazz = [UIView class];
            }
            self.view = [delegate vtDOMElementView:self viewClass:clazz];
        }
        if([delegate respondsToSelector:@selector(vtDOMElement:addView:frame:)]){
            [delegate vtDOMElement:self.parentElement addView:self.view frame:self.frame];
        }
    }
    else{
        self.view = nil;
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

@end
