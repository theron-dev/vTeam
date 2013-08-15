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

typedef  enum {
    VTDOMViewDisplayModeNone,VTDOMViewDisplayModeInited,VTDOMViewDisplayModePart,VTDOMViewDisplayModeRefresh
}VTDOMViewDisplayMode;

@interface VTDOMView(){
    NSMutableSet * _needDisplayElements;
    VTDOMViewDisplayMode _displayMode;
}

@end

@implementation VTDOMView

@synthesize element = _element;
@synthesize allowAutoLayout = _allowAutoLayout;
@synthesize delegate = _delegate;

-(void) dealloc{
    [_needDisplayElements release];
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
    if(_displayMode == VTDOMViewDisplayModePart){
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        for (VTDOMElement * el  in _needDisplayElements) {
            
            CGRect r = [el.parentElement convertRect:el.frame superElement:_element];
            
            if(r.size.width >0 && r.size.height >0){
                
                CGContextSaveGState(ctx);
                
                CGContextTranslateCTM(ctx, r.origin.x, r.origin.y);
                
                CGContextClipToRect(ctx, CGRectMake(0, 0, r.size.width, r.size.height));
                
                [el draw:CGRectMake(0, 0, r.size.width, r.size.height) context:ctx];
                
                CGContextRestoreGState(ctx);
                
            }
            
        }

    }
    else {
        
        [super drawRect:rect];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
          
        [_element render:_element.frame context:ctx];
        
        _displayMode = VTDOMViewDisplayModeInited;
    }
    
    [_needDisplayElements removeAllObjects];
    
}

-(void) viewBindElement:(VTDOMElement *) element{
    [element setDelegate:self];
    for(VTDOMElement * el in  [element childs]){
        [self viewBindElement:el];
    }
}

-(void) viewUnBindElement:(VTDOMElement *) element{
    [element setDelegate:nil];
    for(VTDOMElement * el in  [element childs]){
        [self viewUnBindElement:el];
    }
}


-(void) setElement:(VTDOMElement *)element{
    if(_element != element){
        [self viewUnBindElement:_element];
        [self viewBindElement:element];
        [element retain];
        [_element release];
        _element = element;
        if(_allowAutoLayout){
            [_element layout:self.bounds.size];
        }
        _displayMode = VTDOMViewDisplayModeRefresh;
        [_needDisplayElements removeAllObjects];
        [self setNeedsDisplay];
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(_allowAutoLayout){
        [_element layout:self.bounds.size];
        _displayMode = VTDOMViewDisplayModeRefresh;
    }
    [self setNeedsDisplay];
}

-(CGPoint) locationInElement:(VTDOMElement *) element location:(CGPoint) location{
    
    if(element == _element){
        return location;
    }

    CGRect r = element.frame;
    
    return [self locationInElement:element.parentElement location:CGPointMake(location.x - r.origin.x, location.y - r.origin.y)];
}

-(void) touchesElement:(VTDOMElement *) element location:(CGPoint) location touchType:(int)touchType{
    
    CGRect r = [element frame];
    
    if(location.x >=0 && location.y >=0 && location.x < r.size.width && location.y < r.size.height){

        switch (touchType) {
            case 0:
                [element touchesBegan:location];
                break;
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
 
        for(VTDOMElement * el in [element childs]){
            
            r = [el frame];
            
            [self touchesElement:el location:CGPointMake(location.x - r.origin.x, location.y - r.origin.y) touchType:touchType];
            
        }
    }
    
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
    
    if(_needDisplayElements == nil){
        _needDisplayElements = [[NSMutableSet alloc] initWithCapacity:4];
    }
    
    BOOL hasElement = NO;
    
    VTDOMElement * el = element;
    
    while(el && el != _element){
        
        if([_needDisplayElements containsObject:el]){
            hasElement = YES;
        }
        
        el = [el parentElement];
    }
    
    if(!hasElement){
        [_needDisplayElements addObject:element];
    }
    
    if(_displayMode == VTDOMViewDisplayModeInited){
        _displayMode = VTDOMViewDisplayModePart;
    }
    
    [self setNeedsDisplay];
}

-(void) willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    _displayMode = VTDOMViewDisplayModeNone;
}

@end
