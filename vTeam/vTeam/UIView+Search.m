//
//  UIView+Search.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIView+Search.h"

static void UIViewSearchForClass(UIView * view,Class clazz, NSMutableArray * items){
    if([view isKindOfClass:clazz]){
        [items addObject:view];
    }
    for(UIView * v in [view subviews]){
        UIViewSearchForClass(v,clazz,items);
    }
}

static void UIViewSearchForProtocol(UIView * view,Protocol * protocol, NSMutableArray * items){
    if([view conformsToProtocol:protocol]){
        [items addObject:view];
    }
    for(UIView * v in [view subviews]){
        UIViewSearchForProtocol(v,protocol,items);
    }
}

@implementation UIView (Search)

-(NSArray *) searchViewForClass:(Class) clazz{
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:4];
    UIViewSearchForClass(self,clazz,items);
    return items;
}

-(NSArray *) searchViewForProtocol:(Protocol *) protocol{
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:4];
    UIViewSearchForProtocol(self,protocol,items);
    return items;
}

@end
