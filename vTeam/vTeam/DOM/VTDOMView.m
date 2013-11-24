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


@interface VTDOMView(){
    NSMutableDictionary * _elementViews;
}

-(void) viewBindElement:(VTDOMElement *) element;

-(void) viewUnBindElement:(VTDOMElement *) element;

@end

@implementation VTDOMView

@synthesize element = _element;
@synthesize allowAutoLayout = _allowAutoLayout;
@synthesize delegate = _delegate;

-(void) dealloc{
    for(UIView * v in [_elementViews allValues]){
        if([v respondsToSelector:@selector(setElement:)]){
            [v performSelector:@selector(setElement:) withObject:nil];
        }
    }
    [_elementViews release];
    [self viewUnBindElement:_element];
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
    
    [_element render:_element.frame context:ctx];
}

-(void) viewBindElement:(VTDOMElement *) element{
    [element setDelegate:self];
    for(VTDOMElement * el in  [element childs]){
        [self viewBindElement:el];
    }
}

-(void) viewUnBindElement:(VTDOMElement *) element{
    if(element.delegate == self){
        [element setDelegate:nil];
    }
    for(VTDOMElement * el in  [element childs]){
        [self viewUnBindElement:el];
    }
}


-(void) setElement:(VTDOMElement *)element{
    if(_element != element){
        for (UIView * v in [_elementViews allValues]) {
            [v removeFromSuperview];
        }
        [self viewUnBindElement:_element];
        [element retain];
        [_element release];
        _element = element;
        if(_allowAutoLayout){
            [_element layout:self.bounds.size];
        }
        [self viewBindElement:_element];
        for (id key in [_elementViews allKeys]) {
            UIView * v = [_elementViews objectForKey:key];
            if(v.superview == nil){
                [_elementViews removeObjectForKey:key];
            }
        }
        [self setNeedsDisplay];
    }
}

-(void) setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    if(_allowAutoLayout){
        [_element layout:self.bounds.size];
    }
    [self setNeedsDisplay];
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(_allowAutoLayout){
        [_element layout:self.bounds.size];
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

-(BOOL) touchesElement:(VTDOMElement *) element location:(CGPoint) location touchType:(int)touchType{
    
    CGRect r = [element frame];
    
    if(touchType == 0){
        
        if( touchType || (location.x >=0 && location.y >=0 && location.x < r.size.width
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

    layer.frame = [element convertRect:frame superElement:_element];
    [self.layer addSublayer:layer];
}

-(void) vtDOMElement:(VTDOMElement *) element addView:(UIView *) view frame:(CGRect)frame{
    
    view.frame = [element convertRect:frame superElement:_element];
    
    [self addSubview:view];
}

-(UIView *) vtDOMElementView:(VTDOMElement *) element viewClass:(Class)viewClass{
    NSString * eid = [element attributeValueForKey:@"id"];
    if(eid){
        UIView * v = [_elementViews objectForKey:eid];
        if(v == nil){
            v = [[[viewClass alloc] initWithFrame:element.frame] autorelease];
            if(_elementViews == nil){
                _elementViews = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            [_elementViews setObject:v forKey:eid];
        }
        else{
            v.frame = element.frame;
        }
        return v;
    }
    return nil;
}


@end
