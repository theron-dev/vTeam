//
//  VTDOMView.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMView.h"
#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Control.h"
#import <QuartzCore/QuartzCore.h>

@interface VTDOMViewContainer : NSObject{
    NSMutableDictionary * _viewSetByReuse;
    NSMutableSet * _viewSet;
}

-(UIView *) elementView:(VTDOMElement *) element forClass:(Class) viewClass;

-(void) addElementView:(VTDOMElement *) element view:(UIView *) view;

-(void) removeElementView:(UIView *) view;

-(void) addContainer:(VTDOMViewContainer *) container;

-(void) removeFromSuperView;

-(void) removeAllElementViews;

@end

@implementation VTDOMViewContainer


-(void) dealloc{
    
    for(NSSet * vs in [_viewSetByReuse allValues]){
        
        for(UIView * v in vs){
            if([v respondsToSelector:@selector(setElement:)]){
                [v performSelector:@selector(setElement:) withObject:nil];
            }
            [v removeFromSuperview];
        }
    }
    
    for(UIView * v in _viewSet){
        if([v respondsToSelector:@selector(setElement:)]){
            [v performSelector:@selector(setElement:) withObject:nil];
        }
        [v removeFromSuperview];
    }
    
    [_viewSetByReuse release];
    [_viewSet release];
    
    [super dealloc];
}

-(UIView *) elementView:(VTDOMElement *) element forClass:(Class) viewClass{
    
    NSString * reuse = [element attributeValueForKey:@"reuse"];
    
    NSSet * viewSet = nil;
    
    if([reuse length]){
        viewSet = [_viewSetByReuse valueForKey:reuse];
    }
    
    if(viewSet == nil){
        viewSet = _viewSet;
    }
    
    for (UIView * v in viewSet) {
        if([v class] == viewClass){
            return v;
        }
    }

    return nil;
}

-(void) addElementView:(VTDOMElement *) element view:(UIView *) view{
    
    NSString * reuse = [element attributeValueForKey:@"reuse"];
    
    if([reuse length]){
        
        if(_viewSetByReuse == nil){
            _viewSetByReuse = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        
        NSMutableSet * viewSet = [_viewSetByReuse valueForKey:reuse];
        
        if(viewSet == nil){
            viewSet = [NSMutableSet setWithCapacity:4];
            [_viewSetByReuse setValue:viewSet forKey:reuse];
        }
        
        [viewSet addObject:view];
        
    }
    else {
        if(_viewSet == nil){
            _viewSet = [[NSMutableSet alloc] initWithCapacity:4];
        }
        [_viewSet addObject:view];
    }
    
}

-(void) removeElementView:(UIView *) view{

    for (NSString * key in [_viewSetByReuse allKeys]) {
        
        NSMutableSet * viewSet = [_viewSetByReuse valueForKey:key];
        
        [viewSet removeObject:view];
        
        if([viewSet count] == 0){
            [_viewSetByReuse removeObjectForKey:key];
        }
        
    }
    
    [_viewSet removeObject:view];
    
}

-(void) addContainer:(VTDOMViewContainer *) container{
    
    for (NSString * key in container->_viewSetByReuse) {
        
        NSMutableSet * viewSet = [container->_viewSetByReuse valueForKey:key];
        
        NSMutableSet * tViewSet = [_viewSetByReuse valueForKey:key];
        
        if(tViewSet == nil){
           
            if(_viewSetByReuse == nil){
                _viewSetByReuse = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            
            [_viewSetByReuse setValue:[NSMutableSet setWithSet:viewSet] forKey:key];
        }
        else {
            [tViewSet addObjectsFromArray:[viewSet allObjects]];
        }
        
    }
    
    if(container->_viewSet){
        
        if(_viewSet == nil){
            _viewSet = [[NSMutableSet alloc] initWithCapacity:4];
        }
        
        [_viewSet addObjectsFromArray:[container->_viewSet allObjects]];
        
    }
    
}

-(void) removeFromSuperView{
    
    for (NSString * key in [_viewSetByReuse allKeys]) {
        
        NSMutableSet * viewSet = [_viewSetByReuse valueForKey:key];
        
        for (UIView *v in viewSet) {
            [v removeFromSuperview];
        }

    }
    
    for (UIView *v in _viewSet) {
        [v removeFromSuperview];
    }
    
}

-(void) removeAllElementViews{
    [_viewSetByReuse removeAllObjects];
    [_viewSet removeAllObjects];
}

@end


@interface VTDOMView(){
    VTDOMViewContainer * _viewContainer;
    VTDOMViewContainer * _visableViewContainer;
}

@property(nonatomic,assign) CGSize layoutSize;

@end

@implementation VTDOMView

@synthesize element = _element;
@synthesize allowAutoLayout = _allowAutoLayout;
@synthesize delegate = _delegate;

-(void) dealloc{
    [_viewContainer release];
    [_element unbindDelegate:self];
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
    
    CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
    
    CGRect r = _element.frame;
    
    r.origin = CGPointZero;
    
    [_element render:r context:ctx];
}

-(void) setElement:(VTDOMElement *)element{
    
    if(_element != element){
        
        _layoutSize = CGSizeZero;
        
        if(_viewContainer == nil){
            _viewContainer = [[VTDOMViewContainer alloc] init];
        }
        
        if(_visableViewContainer){
            [_viewContainer addContainer:_visableViewContainer];
            [_visableViewContainer removeAllElementViews];
        }
        
        [_element unbindDelegate:self];
        
        [element retain];
        [_element release];
        _element = element;
        if(_allowAutoLayout){
            _layoutSize = self.bounds.size;
            [_element layout:_layoutSize];
        }
        
        [_element bindDelegate:self];
        
        [_viewContainer removeFromSuperView];
        
        [self setNeedsDisplay];
    }
    
    
}

-(void) setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    if(_allowAutoLayout && !CGSizeEqualToSize(_layoutSize, self.bounds.size)){
        
        _layoutSize = self.bounds.size;
        
        [_element layout:_layoutSize];
        
        if(_viewContainer == nil){
            _viewContainer = [[VTDOMViewContainer alloc] init];
        }
        
        if(_visableViewContainer){
            [_viewContainer addContainer:_visableViewContainer];
            [_visableViewContainer removeAllElementViews];
        }
        
        [_element bindDelegate:self];
        
        [_viewContainer removeFromSuperView];

        [self setNeedsDisplay];
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if(_allowAutoLayout && !CGSizeEqualToSize(_layoutSize, self.bounds.size) ){
        
        _layoutSize = self.bounds.size;
        
        [_element layout:_layoutSize];
        
        if(_viewContainer == nil){
            _viewContainer = [[VTDOMViewContainer alloc] init];
        }
        
        if(_visableViewContainer){
            [_viewContainer addContainer:_visableViewContainer];
            [_visableViewContainer removeAllElementViews];
        }
        
        [_element bindDelegate:self];
        
        [_viewContainer removeFromSuperView];

        [self setNeedsDisplay];
    }
}


-(CGPoint) locationInElement:(VTDOMElement *) element location:(CGPoint) location{
    
    if(element == _element){
        return location;
    }

    CGRect r = element.frame;
    
    return [self locationInElement:element.parentElement location:CGPointMake(location.x - r.origin.x, location.y - r.origin.y)];
}

-(BOOL) touchesElement:(VTDOMElement *) element location:(CGPoint) location touchType:(int)touchType{
    
    if([element isHidden]){
        return NO;
    }
    
    CGRect r = [element frame];
    
    if(touchType == 0){
        
        if((location.x >=0 && location.y >=0 && location.x < r.size.width
                          && location.y < r.size.height)){
            
            NSInteger index = [[element childs] count] -1;
            
            for (; index >=0; index --) {
                
                VTDOMElement * el = [[element childs] objectAtIndex:index];
                
                r = [el frame];
                
                if([self touchesElement:el location:CGPointMake(location.x - r.origin.x, location.y - r.origin.y) touchType:touchType]){
                    return YES;
                }
                
            }
            
            if([element touchesBegan:location]){
                return YES;
            }
        }
        
    }
    else{
        
        for(VTDOMElement * el in [element childs]){
            
            r = [el frame];
            
            if([self touchesElement:el location:CGPointMake(location.x - r.origin.x, location.y - r.origin.y) touchType:touchType]){
                return YES;
            }
            
        }
        
        switch (touchType) {
            case 1:
                [element touchesEnded:location];
                break;
            case 2:
                [element touchesCancelled:location];
                break;
            case 3:
                [element touchesMoved:location];
                break;
            default:
                break;
        }
    }
    
    return NO;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesElement:_element location:location touchType:0];
    
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesElement:_element location:location touchType:1];
    
    [super touchesEnded:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesElement:_element location:location touchType:2];
    
    [super touchesCancelled:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self touchesElement:_element location:location touchType:3];
    
    [super touchesMoved:touches withEvent:event];
}

-(void) vtDOMElementDoAction:(VTDOMElement *) element{
    if([_delegate respondsToSelector:@selector(vtDOMView:doActionElement:)]){
        [_delegate vtDOMView:self doActionElement:element];
    }
}

-(void) vtDOMElementDoNeedDisplay:(VTDOMElement *) element{
    [self setNeedsDisplay];
}

-(void) vtDOMElement:(VTDOMElement *) element addLayer:(CALayer *) layer frame:(CGRect)frame{

    layer.frame = element ? [element convertRect:frame superElement:_element] : frame;
    
    [self.layer addSublayer:layer];
}

-(void) vtDOMElement:(VTDOMElement *) element addView:(UIView *) view frame:(CGRect)frame{
    
    view.frame = element ? [element convertRect:frame superElement:_element] : frame;
    
    [self addSubview:view];
    
}

-(CGRect) vtDOMElement:(VTDOMElement *) element convertRect:(CGRect) frame{
    return element ? [element convertRect:frame superElement:_element] : frame;
}

-(UIView *) vtDOMElementView:(VTDOMElement *) element viewClass:(Class)viewClass{
    
    UIView * v = nil;
    
    if([self.delegate respondsToSelector:@selector(vtDOMView:elementView:viewClass:)]){
        if((v = [self.delegate vtDOMView:self elementView:element viewClass:viewClass])){
            return v;
        }
    }
    
    v = [_viewContainer elementView:element forClass:viewClass];
    
    if(v == nil){
        v = [[[viewClass alloc] initWithFrame:element.frame] autorelease];
    }
    else {
        v.frame = element.frame;
        [[v retain] autorelease];
        [_viewContainer removeElementView:v];
    }
   
    if(_visableViewContainer == nil){
        _visableViewContainer = [[VTDOMViewContainer alloc] init];
    }
    
    [_visableViewContainer addElementView:element view:v];
    
    return v;
}


@end
