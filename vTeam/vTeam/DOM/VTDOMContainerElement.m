//
//  VTDOMContainerElement.m
//  vTeam
//
//  Created by zhang hailong on 14-2-16.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMContainerElement.h"

#import "VTDOMView.h"
#import "VTDOMElement+Style.h"
#import "VTDOMElement+Layout.h"

@interface VTDOMContainerItemView : VTDOMView

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,retain) NSString * reuseIdentifier;

@end


@implementation VTDOMContainerItemView

@synthesize index = _index;
@synthesize reuseIdentifier = _reuseIdentifier;

-(void) dealloc{
    [_reuseIdentifier release];
    [super dealloc];
}

@end

@interface VTDOMContainerElement()

@property(nonatomic,readonly) NSMutableArray * dequeueItemViews;

@end

@implementation VTDOMContainerElement

@synthesize dequeueItemViews = _dequeueItemViews;

-(NSMutableArray *) dequeueItemViews{
    if(_dequeueItemViews == nil){
        _dequeueItemViews = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return _dequeueItemViews;
}


-(void) dealloc{
    
    if([self isViewLoaded]){
        [[self contentView] setDelegate:nil];
        [self.contentView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [_dequeueItemViews release];
    
    [super dealloc];
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize contentSize = [super layoutChildren:padding];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
    }
    
    return contentSize;
}

-(void) render:(CGRect) rect context:(CGContextRef) context{
    
}

-(UIScrollView *) contentView{
    return (UIScrollView *) self.view;
}

-(Class) viewClass{
    NSString * view = [self stringValueForKey:@"viewClass"];
    Class clazz = NSClassFromString(view);
    if(clazz == nil || ![clazz isSubclassOfClass:[UIScrollView class]]){
        clazz = [UIScrollView class];
    }
    return clazz;
}

-(void) setView:(UIView *)view{
    
    [self.contentView setDelegate:nil];
    [self.contentView removeObserver:self forKeyPath:@"contentOffset"];
    
    [super setView:view];
    
    [self.contentView setContentInset:[self edgeInsetsValueForKey:@"content-inset"]];
    [self.contentView setScrollIndicatorInsets:[self edgeInsetsValueForKey:@"scroll-inset"]];
    [self.contentView setContentSize:self.contentSize];
    [self.contentView setShowsHorizontalScrollIndicator:NO];
    [self.contentView setDelegate:self];
    [self.contentView addObserver:self forKeyPath:@"contentOffset"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    [self reloadData];
}

-(void) reloadData{
    
    UIScrollView * contentView = [self contentView];
    
    if(contentView){
        
        NSMutableDictionary * itemViews = [NSMutableDictionary dictionaryWithCapacity:4];
        
        NSMutableArray * dequeueItemViews = [self dequeueItemViews];
        
        for (VTDOMContainerItemView * itemView in [contentView subviews]) {
            
            if([itemView isKindOfClass:[VTDOMContainerItemView class]]){
                
                [itemViews setObject:itemView forKey:[NSNumber numberWithInt:itemView.index]];
                
            }
            
        }
        
        NSInteger index = 0;
        
        VTDOMView * domView = self.delegate;
        
        if(![domView isKindOfClass:[VTDOMView class]]){
            domView = nil;
        }
        
        for (VTDOMElement * element in [self childs]) {
            
            CGRect r = [self frameInElement:element];

            if([self isVisableRect:r]){
                
                NSString * reuseIdentifier = [element attributeValueForKey:@"reuse"];
                
                VTDOMContainerItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:index]];
                
                if(itemView == nil){
                    
                    for(itemView in dequeueItemViews){
                        if(reuseIdentifier == nil || [reuseIdentifier isEqualToString:itemView.reuseIdentifier]){
                            break;
                        }
                    }
                    
                }
                
                if(itemView == nil){
                    itemView = [[[VTDOMContainerItemView alloc] initWithFrame:r] autorelease];
                    [itemView setBackgroundColor:[UIColor clearColor]];
                    [itemView setAllowAutoLayout:NO];
                    [contentView addSubview:itemView];
                }
                
                itemView.delegate = domView.delegate;
                
                [itemView setReuseIdentifier:reuseIdentifier];
                [itemView setFrame:r];
                
                if(itemView.superview == nil){
                    [contentView addSubview:itemView];
                }
                
                if(itemView.index == NSNotFound){
                    [dequeueItemViews removeObject:itemView];
                }
                
                [itemView setIndex:index];
                
                if(itemView.element != element){
                    
                    [itemView setElement:element];
                    
                    if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForElement:)]){
                        [[domView delegate] vtDOMView:domView downloadImagesForElement:element];
                    }
                    
                    if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForView:)]){
                        [[domView delegate] vtDOMView:domView downloadImagesForView:itemView];
                    }
                    
                }
                
                [itemViews removeObjectForKey:[NSNumber numberWithInt:index]];
                
            }
            else{
                
                VTDOMContainerItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:index]];
                
                if(itemView){
                    [itemView setIndex:NSNotFound];
                    [itemView setElement:nil];
                    [itemViews removeObjectForKey:[NSNumber numberWithInt:index]];
                    [dequeueItemViews addObject:itemView];
                }
            }
            
            index ++;
        }
        
        for (VTDOMContainerItemView * itemView in [itemViews allValues]) {
            
            [itemView removeFromSuperview];
            
        }
        
        for (VTDOMContainerItemView * itemView in dequeueItemViews) {
            
            [itemView removeFromSuperview];
            
        }
    }
}

-(BOOL) isVisableRect:(CGRect) frame{
    UIScrollView * contentView = [self contentView];
    CGRect rect = contentView.bounds;
    rect.origin = contentView.contentOffset;
    CGRect rs = CGRectIntersection(rect, frame);
    return rs.size.width >0 && rs.size.height > 0;
}

-(CGRect) frameInElement:(VTDOMElement *) element{
    return [element frame];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([self isViewLoaded] && self.contentView == object
       && [keyPath isEqualToString:@"contentOffset"]){
        
        [self reloadData];
        
    }
    
}

@end
