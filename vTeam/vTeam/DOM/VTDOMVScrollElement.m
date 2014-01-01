//
//  VTDOMVScrollElement.m
//  vTeam
//
//  Created by zhang hailong on 14-1-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMVScrollElement.h"

#import "VTDOMView.h"

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"

@interface VTDOMVScrollItemView : VTDOMView

@property(nonatomic,assign) NSInteger index;

@end

@implementation VTDOMVScrollItemView

@synthesize index = _index;

@end

@implementation VTDOMVScrollElement


-(void) dealloc{
    
    if([self isViewLoaded]){
        [[self contentView] setDelegate:nil];
        [self.contentView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [super dealloc];
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(0, 0);
    
    for (VTDOMElement * element in [self childs]) {
        
        [element layout:size];
        
        CGRect r = element.frame;
        UIEdgeInsets margin = [element margin];
        
        contentSize.height += r.size.height + margin.top + margin.bottom;
    }
    
    [self setContentSize:contentSize];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
    }
    
    return size;
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
    
    [self.contentView setContentSize:self.contentSize];
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
        
        NSMutableArray * dequeueItemViews = [NSMutableArray arrayWithCapacity:4];
        
        for (VTDOMVScrollItemView * itemView in [contentView subviews]) {
            
            if([itemView isKindOfClass:[VTDOMVScrollItemView class]]){
                
                [itemViews setObject:itemView forKey:[NSNumber numberWithInt:itemView.index]];
                
            }
            
        }
        
        NSInteger index = 0;
        
        VTDOMView * domView = self.delegate;
        
        if(![domView isKindOfClass:[VTDOMView class]]){
            domView = nil;
        }
        
        CGSize size = contentView.bounds.size;
        CGSize contentSize = CGSizeMake(0, 0);
        
        for (VTDOMElement * element in [self childs]) {
            
            CGRect r = element.frame;
            
            UIEdgeInsets margin = [element margin];
            
            r.origin.x = 0;
            r.origin.y = contentSize.height + margin.top;
            r.size.width = size.width;
            
            contentSize.height += r.size.height + margin.top + margin.bottom;
            
            if([self isVisableRect:r]){
                
                VTDOMVScrollItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:index]];
                
                if(itemView == nil){
                    itemView = [dequeueItemViews lastObject];
                    if(itemView){
                        [dequeueItemViews removeLastObject];
                    }
                }
                
                if(itemView == nil){
                    itemView = [[[VTDOMVScrollItemView alloc] initWithFrame:r] autorelease];
                    [itemView setBackgroundColor:[UIColor clearColor]];
                    [itemView setAllowAutoLayout:NO];
                    [contentView addSubview:itemView];
                }
                
                
                itemView.delegate = domView.delegate;
                
                [itemView setFrame:r];
                [itemView setIndex:index];
                
                if(itemView.element != element){
                    
                    [itemView setElement:element];
                    
                    if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForView:)]){
                        [[domView delegate] vtDOMView:domView downloadImagesForView:itemView];
                    }
                    
                }
                
                [itemViews removeObjectForKey:[NSNumber numberWithInt:index]];
                
            }
            else{
                
                VTDOMVScrollItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:index]];
                
                if(itemView){
                    [itemView setIndex:NSNotFound];
                    [itemViews removeObjectForKey:[NSNumber numberWithInt:index]];
                    [dequeueItemViews addObject:itemView];
                }
            }
            
            index ++;
        }
        
        for (VTDOMVScrollItemView * itemView in [itemViews allValues]) {
            
            [itemView removeFromSuperview];
            
        }
        
        for (VTDOMVScrollItemView * itemView in dequeueItemViews) {
            
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

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([self isViewLoaded] && self.contentView == object
       && [keyPath isEqualToString:@"contentOffset"]){
        
        [self reloadData];
        
    }
    
}

@end
