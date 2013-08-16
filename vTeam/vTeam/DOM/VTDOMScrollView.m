//
//  VTDOMScrollView.m
//  vTeam
//
//  Created by zhang hailong on 13-8-16.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMScrollView.h"

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Control.h"

#import <QuartzCore/QuartzCore.h>

@interface VTDOMScrollView(){
    NSMutableArray * _contentViews;
}

@property(nonatomic,assign) CGSize layoutSize;

-(void) reloadContents:(BOOL) reloadData;

@end

@interface VTDOMScrollContentView : UIView

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,retain) VTDOMElement * element;


@end

@implementation VTDOMScrollContentView

@synthesize pageIndex = _pageIndex;
@synthesize element = _element;

-(void) dealloc{
    [_element release];
    [super dealloc];
}

-(void) setPageIndex:(NSInteger)pageIndex{
    _pageIndex = pageIndex;
    [self setNeedsDisplay];
}

-(void) setElement:(VTDOMElement *)element{
    if(_element != element){
        [element retain];
        [_element release];
        _element = element;
        [self setNeedsDisplay];
    }
}

-(void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0, - _pageIndex * self.bounds.size.height);
    
    [_element render:_element.frame context:ctx];
}

@end


@implementation VTDOMScrollView

@synthesize layoutSize = _layoutSize;
@synthesize element = _element;

-(void) dealloc{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


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
        [self reloadContents:YES];
    }
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reloadContents:NO];

}

-(void) setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    [self reloadContents:NO];
}

-(BOOL) isVisablePage:(NSInteger) pageIndex{
    CGRect rect = self.bounds;
    rect.origin = self.contentOffset;
    CGRect rs = CGRectIntersection(rect, CGRectMake(0, pageIndex * rect.size.height, rect.size.width, rect.size.height));
    return rs.size.width >0 && rs.size.height > 0;
}

-(void) reloadContents:(BOOL) reloadData{
    
    if(_element){
        
        CGSize contentSize = self.contentSize;
        
        if(!CGSizeEqualToSize(self.bounds.size, _layoutSize) || reloadData){
            
            _layoutSize = self.bounds.size;
    
            contentSize = [_element layout:CGSizeMake(_layoutSize.width, INT32_MAX)];
            
            [self setContentSize:CGSizeMake(0, contentSize.height)];
        }
        
        NSInteger pageIndex = 0;
        
        NSMutableDictionary * contentViews = [NSMutableDictionary dictionaryWithCapacity:4];
        
        for(VTDOMScrollContentView * contentView in _contentViews){
            
            NSInteger index = [contentView pageIndex];
            
            if(index != NSNotFound){
                [contentViews setObject:contentView forKey:[NSNumber numberWithInteger:index]];
            }
            
        }
        
        while(pageIndex * _layoutSize.height < contentSize.height){
            
            NSNumber * key = [NSNumber numberWithInteger:pageIndex];
            
            if([self isVisablePage:pageIndex]){
                
                VTDOMScrollContentView * contentView = [contentViews objectForKey:key];
                
                CGRect r = CGRectMake(0, pageIndex * _layoutSize.height, _layoutSize.width, _layoutSize.height);
                
                if(contentView == nil){
                    
                    for(contentView in _contentViews){
                        if(contentView.pageIndex == NSNotFound){
                            break;
                        }
                    }
                    
                    if(contentView == nil || contentView.pageIndex != NSNotFound){
                        
                        contentView = [[VTDOMScrollContentView alloc] initWithFrame:r];
                        [contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                        [contentView setPageIndex:pageIndex];
                        [contentView setElement:_element];
                        [contentView setBackgroundColor:[UIColor clearColor]];
                        
                        if(_contentViews == nil){
                            _contentViews = [[NSMutableArray alloc] initWithCapacity:4];
                        }
                        
                        [_contentViews addObject:contentView];
                        
                    }
                    else{
                        [contentView setPageIndex:pageIndex];
                        [contentView setElement:_element];
                        [contentView setFrame:r];
                    }

                    [self insertSubview:contentView atIndex:0];
                }
                else{
                    contentView.frame = r;
                    if(reloadData){
                        [contentView setElement:_element];
                    }
                    [contentViews removeObjectForKey:key];
                }
            
            }
            else{
                
                VTDOMScrollContentView * contentView = [contentViews objectForKey:key];
                
                if(contentView){
                    [contentView setPageIndex:NSNotFound];
                    [contentView removeFromSuperview];
                    [contentViews removeObjectForKey:key];
                }
                
            }
            
            pageIndex ++;
        }
        
        for(VTDOMScrollContentView * contentView in [contentViews allValues]){
            [contentView removeFromSuperview];
            [contentView setPageIndex:NSNotFound];
            [contentView setElement:nil];
        }
        
    }
    else{
        for(VTDOMScrollContentView * contentView in _contentViews){
            [contentView removeFromSuperview];
            [contentView setPageIndex:NSNotFound];
            [contentView setElement:nil];
        }
        [_contentViews removeAllObjects];
    }
    
}

-(void) setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    [self reloadContents:NO];
}

-(void) vtDOMElementDoAction:(VTDOMElement *) element{
    
}

-(void) vtDOMElementDoNeedDisplay:(VTDOMElement *) element{
    
}

-(void) vtDOMElement:(VTDOMElement *) element addLayer:(CALayer *) layer frame:(CGRect)frame{
    
    layer.frame = [element convertRect:frame superElement:_element];
    [self.layer addSublayer:layer];
}

-(void) vtDOMElement:(VTDOMElement *) element addView:(UIView *) view frame:(CGRect)frame{
    
    view.frame = [element convertRect:frame superElement:_element];
    [self addSubview:view];
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


@end
