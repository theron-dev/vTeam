//
//  VTDocumentView.m
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDocumentView.h"

#import "IVTLayoutElement.h"

#import "VTElement+Value.h"

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
        
        NSMutableSet * views = [_viewsById valueForKey:elementId];
        
        for (UIView * view in views) {
            
            if([view class] ==viewClass){
                
                v = view;
                
                [views removeObject:view];
                
                break;
            }
            
        }
        
    }
    else if([reuse length]){
        
        NSMutableSet * views = [_viewsByReuse valueForKey:reuse];
        
        for (UIView * view in views) {
            
            if([view class] ==viewClass){
                
                v = view;
                
                [views removeObject:view];
                
                break;
            }
            
        }
    
    }
    else {
        
        for (UIView * view in _views) {
            
            if([view class] ==viewClass){
                
                v = view;
                
                [_views removeObject:view];
                
                break;
            }
            
        }
    }
    
    return v;
}

-(void) removeAllView{
    
    for (NSMutableSet * views in [_viewsById allValues]) {
        
        for (UIView * view in views) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    for (NSMutableSet * views in [_viewsByReuse allValues]) {
        
        for (UIView * view in views) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    for (UIView * view in _views) {
        
        [view removeFromSuperview];
        
    }
    
}

@end


@interface VTDocumentView(){
    CGSize _layoutSize;
    VTDocumentViewContainer * _viewContainer;
    VTDocumentViewContainer * _creatorViewContainer;
    VTDocumentViewContainer * _dequeueViewContainer;
}

@end

@implementation VTDocumentView

@synthesize allowAutoLayout = _allowAutoLayout;
@synthesize element = _element;
@synthesize delegate = _delegate;


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
        
        if(_element){
            
            _layoutSize = self.bounds.size;
            
            if(_allowAutoLayout && [_element conformsToProtocol:@protocol(IVTLayoutElement)]){
                [(id<IVTLayoutElement>) _element layout:_layoutSize];
            }
    
            _creatorViewContainer = [[VTDocumentViewContainer alloc] init];
            
            _dequeueViewContainer = _viewContainer;
            
            _viewContainer = nil;
            
            [_element setViewEntity:self];
            
            [_dequeueViewContainer removeAllView];
            _dequeueViewContainer = nil;
            
            _viewContainer = _creatorViewContainer;
            _creatorViewContainer = nil;
    
        }
        
        [self setNeedsDisplay];
    }
    
}


-(void) elementDoAction:(id<IVTViewEntity>) viewEntity element:(VTElement *) element{
    
    if([_delegate respondsToSelector:@selector(documentView:onActionViewEntity:element:)]){
        [_delegate documentView:self onActionViewEntity:viewEntity element:element];
    }
    
}

-(void) elementDoNeedsDisplay:(VTElement *) element{
    [self setNeedsDisplay];
}

-(CGRect) elementFrameConvert:(VTElement *) element{
    
    CGRect r = CGRectZero;
    
    id<IVTLayoutElement> fElement = nil;
    VTElement * el = element;
    
    while(el != nil && el != _element){
        
        if([el conformsToProtocol:@protocol(IVTLayoutElement)]){
            
            id<IVTLayoutElement> layoutElement = (id<IVTLayoutElement>) el;
            
            CGRect frame = [layoutElement frame];
      
            if(fElement == nil){
                fElement = layoutElement;
                r.size.width = frame.size.width;
                r.size.height = frame.size.height;
            }
            
            r.origin.x += frame.origin.x;
            r.origin.y += frame.origin.y;
            
        }
        
        el = [el parentElement];
    }
    
    if(fElement == nil && el == _element){
        if([el conformsToProtocol:@protocol(IVTLayoutElement)]){
            
            id<IVTLayoutElement> layoutElement = (id<IVTLayoutElement>) el;
            
            CGRect frame = [layoutElement frame];
            
            r.size.width = frame.size.width;
            r.size.height = frame.size.height;
            
        }
        
    }
    
    return r;

}

-(UIView *) elementViewOf:(VTElement *) element viewClass:(Class) viewClass{
    
    NSString * elementId = [element elementId];
    NSString * reuse = [element stringValueForKey:@"reuse"];

    UIView * view = nil;
    
    CGRect frame = [self elementFrameConvert:element];
    
    if(view == nil && _dequeueViewContainer){
        view = [_dequeueViewContainer view:elementId reuse:reuse viewClass:viewClass];
    }
    
    if(view == nil){
        view = [[viewClass alloc] initWithFrame:frame];
    }
    else {
        view.frame = frame;
    }
    
    if(_creatorViewContainer){
        [_creatorViewContainer addView:view elementId:elementId reuse:reuse];
    }
    
    if(view.superview != self){
        [self addSubview:view];
    }
    
    return view;
}

-(void) elementLayoutView:(VTElement *) element view:(UIView *) view{

    view.frame = [self elementFrameConvert:element];

}

-(void) elementVisable:(id<IVTViewEntity>) viewEntity element:(VTElement *) element{
    
    if([_delegate respondsToSelector:@selector(documentView:onVisableViewEntity:element:)]){
        [_delegate documentView:self onVisableViewEntity:viewEntity element:element];
    }
    
}

-(void) setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    if(CGSizeEqualToSize(_layoutSize, bounds.size)){
        _layoutSize = bounds.size;
        if(_allowAutoLayout && [_element conformsToProtocol:@protocol(IVTLayoutElement)]){
            [(id<IVTLayoutElement>) _element layout:_layoutSize];
        }
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(CGSizeEqualToSize(_layoutSize, self.bounds.size)){
        _layoutSize = self.bounds.size;
        if(_allowAutoLayout && [_element conformsToProtocol:@protocol(IVTLayoutElement)]){
            [(id<IVTLayoutElement>) _element layout:_layoutSize];
        }
    }
}

@end
