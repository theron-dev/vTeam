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
#import "VTDOMStatusElement.h"

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
@property(nonatomic,retain) VTDOMStatusElement * statusElement;

@end

@implementation VTDOMContainerElement

@synthesize dequeueItemViews = _dequeueItemViews;
@synthesize statusElement = _statusElement;

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
    [_statusElement release];
    
    [super dealloc];
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize contentSize = [super layoutChildren:padding];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
        [self reloadData];
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
        
        CGPoint contentOffset = contentView.contentOffset;
        CGSize size = contentView.bounds.size;
        UIEdgeInsets contentInset = contentView.contentInset;
        CGPoint bottomOffset = CGPointMake(contentOffset.x + size.width - contentInset.left - contentInset.right, contentOffset.y + size.height - contentInset.top - contentInset.bottom);
        
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
        
        self.statusElement = nil;
        
        for (VTDOMElement * element in [self childs]) {
            
            CGRect r = [self frameInElement:element];

            NSNumber * key = [NSNumber numberWithInt:index];
            
            if([self isVisableRect:r]){
                
                if([element isKindOfClass:[VTDOMStatusElement class]]
                   && ![[(VTDOMStatusElement *) element status] isEqualToString:@"loading"]){
                    
                    NSString * target = [element attributeValueForKey:@"target"];
                    
                    if(r.origin.y < 0 && contentOffset.y < 0 && [target isEqualToString:@"top"]){
                        if(r.origin.y - contentOffset.y >= 0){
                            [(VTDOMStatusElement *) element setStatus:@"topover"];
                        }
                        else{
                            [(VTDOMStatusElement *) element setStatus:@"top"];
                        }
                        self.statusElement = (VTDOMStatusElement *) element;
                    }
                    else if(bottomOffset.y > r.origin.y && [target isEqualToString:@"bottom"]){
                        if(bottomOffset.y >= r.origin.y + r.size.height){
                            [(VTDOMStatusElement *) element setStatus:@"bottomover"];
                        }
                        else{
                            [(VTDOMStatusElement *) element setStatus:@"bottom"];
                        }
                        self.statusElement = (VTDOMStatusElement *) element;
                    }
                    else if(bottomOffset.x > r.origin.x && [target isEqualToString:@"right"]){
                        if(bottomOffset.x >= r.origin.x + r.size.width){
                            [(VTDOMStatusElement *) element setStatus:@"rightover"];
                        }
                        else{
                            [(VTDOMStatusElement *) element setStatus:@"right"];
                        }
                        self.statusElement = (VTDOMStatusElement *) element;
                    }
                    else if(r.origin.x < 0 && contentOffset.x < 0 && [target isEqualToString:@"left"]){
                        if(r.origin.x - contentOffset.x >= 0){
                            [(VTDOMStatusElement *) element setStatus:@"leftover"];
                        }
                        else{
                            [(VTDOMStatusElement *) element setStatus:@"left"];
                        }
                        self.statusElement = (VTDOMStatusElement *) element;
                    }
                    else{
                        [(VTDOMStatusElement *) element setStatus:nil];
                    }
                    
                }
                
                NSString * reuseIdentifier = [element attributeValueForKey:@"reuse"];
                
                VTDOMContainerItemView * itemView = [itemViews objectForKey:key];
                
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
                    [contentView insertSubview:itemView atIndex:0];
                }
                
                itemView.delegate = domView.delegate;
                
                [itemView setReuseIdentifier:reuseIdentifier];
                [itemView setFrame:r];
                
                if(itemView.superview == nil){
                    [contentView insertSubview:itemView atIndex:0];
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
                    
                    
                    [self didVisableItemView:domView element:element atIndex:index];
                    
                }
                
                [itemViews removeObjectForKey:[NSNumber numberWithInt:index]];
                
            }
            else{
                
                VTDOMContainerItemView * itemView = [itemViews objectForKey:key];
                
                if(itemView){
                    [itemView setIndex:NSNotFound];
                    [itemView setElement:nil];
                    [dequeueItemViews addObject:itemView];
                    [itemViews removeObjectForKey:key];
                    [itemView removeFromSuperview];
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

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_statusElement){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:_statusElement];
        }
        
        self.statusElement = nil;
    }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if(_statusElement){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:_statusElement];
        }
        
        self.statusElement = nil;
    }
    
}

-(void) didVisableItemView:(UIView *) itemView element:(VTDOMElement *) element atIndex:(NSInteger) index{
    
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reloadData];
}

@end
