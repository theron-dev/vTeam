//
//  VTDOMPageScrollElement.m
//  vTeam
//
//  Created by zhang hailong on 14-1-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMPageScrollElement.h"

#import "VTDOMView.h"

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"

@interface VTDOMPageScrollItemView : VTDOMView

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,retain) NSString * reuseIdentifier;

@end

@implementation VTDOMPageScrollItemView

@synthesize pageIndex = _pageIndex;
@synthesize reuseIdentifier = _reuseIdentifier;

-(void) dealloc{
    [_reuseIdentifier release];
    [super dealloc];
}

@end

@interface VTDOMPageScrollElement()


@property(nonatomic,readonly) NSMutableArray * dequeueItemViews;

@end

@implementation VTDOMPageScrollElement

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
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(0, 0);
    
    for (VTDOMElement * element in [self childs]) {
        
        [element layout:size];
    
        contentSize.width += size.width;
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
    [self.contentView setPagingEnabled:YES];
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
        
        for (VTDOMPageScrollItemView * itemView in [contentView subviews]) {
            
            if([itemView isKindOfClass:[VTDOMPageScrollItemView class]]){
                
                [itemViews setObject:itemView forKey:[NSNumber numberWithInt:itemView.pageIndex]];
                
            }
            
        }
        
        NSInteger pageIndex = 0;
        
        VTDOMView * domView = self.delegate;
        
        if(![domView isKindOfClass:[VTDOMView class]]){
            domView = nil;
        }
        
        CGSize size = contentView.bounds.size;
        
        for (VTDOMElement * element in [self childs]) {
            
            CGRect r = CGRectMake(pageIndex * size.width, 0, size.width, size.height);
            
            if([self isVisableRect:r]){
                
                VTDOMPageScrollItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:pageIndex]];
                
                NSString * reuseIdentifier = [element attributeValueForKey:@"reuse"];
                
                if(itemView == nil){
                    
                    for(itemView in dequeueItemViews){
                        if(reuseIdentifier == nil || [reuseIdentifier isEqualToString:itemView.reuseIdentifier]){
                            break;
                        }
                    }
                }
                
                if(itemView == nil){
                    itemView = [[[VTDOMPageScrollItemView alloc] initWithFrame:r] autorelease];
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
                
                if(itemView.pageIndex == NSNotFound){
                    [dequeueItemViews removeObject:itemView];
                }
                
                [itemView setPageIndex:pageIndex];
                
                if(itemView.element != element){
                    
                    [itemView setElement:element];
                    
                    if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForElement:)]){
                        [[domView delegate] vtDOMView:domView downloadImagesForElement:element];
                    }
                    
                    if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForView:)]){
                        [[domView delegate] vtDOMView:domView downloadImagesForView:itemView];
                    }
                    
                }
                
                [itemViews removeObjectForKey:[NSNumber numberWithInt:pageIndex]];
                
            }
            else{
                
                VTDOMPageScrollItemView * itemView = [itemViews objectForKey:[NSNumber numberWithInt:pageIndex]];
                
                if(itemView){
                    [itemView setPageIndex:NSNotFound];
                    [itemViews removeObjectForKey:[NSNumber numberWithInt:pageIndex]];
                    [dequeueItemViews addObject:itemView];
                }
            }
            
            pageIndex ++;
        }
        
        for (VTDOMPageScrollItemView * itemView in [itemViews allValues]) {
            
            [itemView removeFromSuperview];
            
        }
        
        for (VTDOMPageScrollItemView * itemView in dequeueItemViews) {
            
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
