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

+(CGRect) sizeToFit:(CGRect) rect element:(VTDOMElement *) element{
    return rect;
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        CGRect rr = r;
        
        Class clazz = [self viewClass];
        
        if([clazz methodForSelector:@selector(sizeToFit:element:)]){
            rr = [clazz sizeToFit:r element:self];
        }
        else {
            if(rr.size.width == MAXFLOAT){
                rr.size.width = 0;
            }
            if(rr.size.height == MAXFLOAT){
                rr.size.height = 0;
            }
        }
        
        if(r.size.width == MAXFLOAT){
            r.size.width = rr.size.width + padding.left + padding.right;
            NSString * min = [self stringValueForKey:@"min-width"];
            if(min){
                if(r.size.width < [min floatValue]){
                    r.size.width = [min floatValue];
                }
            }
            NSString * max = [self stringValueForKey:@"max-width"];
            if(max){
                if(r.size.width > [max floatValue]){
                    r.size.width = [max floatValue];
                }
            }
        }
        
        if(r.size.height == MAXFLOAT){
            r.size.height = rr.size.height + padding.top + padding.bottom;
            NSString * min = [self stringValueForKey:@"min-height"];
            if(min){
                if(r.size.height < [min floatValue]){
                    r.size.height = [min floatValue];
                }
            }
            NSString * max = [self stringValueForKey:@"max-height"];
            if(max){
                if(r.size.height > [max floatValue]){
                    r.size.height = [max floatValue];
                }
            }
        }
        
        [self setFrame:r];
        
    }
    return r.size;
}

-(void) unbindDelegate:(id)delegate{
    if(self.delegate == delegate){
        self.delegate = nil;
    }
}

-(void) bindDelegate:(id)delegate{
    self.delegate = delegate;
}

@end
