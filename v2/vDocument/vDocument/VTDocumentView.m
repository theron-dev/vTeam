//
//  VTDocumentView.m
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDocumentView.h"

@interface VTDocumentViewContainer : NSObject{
    NSMutableDictionary * _viewsById;
    NSMutableDictionary  * _viewsByReuse;
    NSMutableSet * _views;
}

-(void) addView:(UIView *) view elementId:(NSString *) elementId reuse:(NSString *) reuse;

-(UIView *) view:(NSString *) elementId reuse:(NSString *) reuse viewClass:(Class) viewClass;

-(void) removeAllView;

@end

@implementation VTDocumentViewContainer

-(void) addView:(UIView *) view elementId:(NSString *) elementId reuse:(NSString *) reuse{
   
    if([elementId length]){
        
        if(_viewsById == nil){
            _viewsById = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        NSMutableSet * views = [_viewsById valueForKey:elementId];
        
        if(views == nil){
            views = [[NSMutableSet alloc] initWithCapacity:4];
            [_viewsById setValue:views forKey:elementId];
        }
        
        [views addObject:view];
        
    }
    else if([reuse length]){
        
        if(_viewsByReuse == nil){
            _viewsByReuse = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        NSMutableSet * views = [_viewsByReuse valueForKey:elementId];
        
        if(views == nil){
            views = [[NSMutableSet alloc] initWithCapacity:4];
            [_viewsByReuse setValue:views forKey:elementId];
        }
        
        [views addObject:view];
        
    }
    else {
        
        if(_views == nil){
            _views = [[NSMutableSet alloc] initWithCapacity:4];
        }
        
        [_views addObject:view];
    }
}

-(UIView *) view:(NSString *) elementId reuse:(NSString *) reuse viewClass:(Class) viewClass{
    
    __block UIView * v = nil;;
    
    if([elementId length]){
        
        
        v = [_viewsById valueForKey:elementId];
        
        if(v && [v class] != viewClass){
            v = nil;
        }
        
    }
    else if([reuse length]){
        
        if(_viewsByReuse == nil){
            _viewsByReuse = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        NSMutableSet * views = [_viewsByReuse valueForKey:elementId];
        
        if(views == nil){
            views = [[NSMutableSet alloc] initWithCapacity:4];
            [_viewsByReuse setValue:views forKey:elementId];
        }
        
        [views addObject:view];
        
    }
    else {
        
        if(_views == nil){
            _views = [[NSMutableSet alloc] initWithCapacity:4];
        }
        
        [_views addObject:view];
    }
    
    return v;
}

-(void) removeAllView;

@end


@interface VTDocumentView(){
    CGSize _layoutSize;
}

@end

@implementation VTDocumentView

@synthesize allowAutoLayout = _allowAutoLayout;
@synthesize element = _element;

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

-(void) dealloc{
    
    [_element setViewEntity:nil];
    
}

-(void) setElement:(VTElement *)element{
    
    if(_element != element){
        
        if([_element viewEntity] == self){
            [_element setViewEntity:nil];
        }
        
        _element = element;
        
        
        
    }
    
}


@end
