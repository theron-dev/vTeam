//
//  VTContainerView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTContainerView.h"

@interface VTContainerView(){
    NSMutableArray * _queueItemViewControllers;
    NSMutableArray * _itemViewControllers;
}


@end

@implementation VTContainerView

@synthesize containerLayout = _containerLayout;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize backgroundView = _backgroundView;
@synthesize focusIndex = _focusIndex;
@synthesize visableEdgeInsets = _visableEdgeInsets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) dealloc{
    [self setDelegate:nil];
    [_containerLayout release];
    [_queueItemViewControllers release];
    [_itemViewControllers release];
    [_headerView release];
    [_footerView release];
    [_backgroundView release];
    [super dealloc];
}

-(void) addItemViewController:(id) viewController{
    if(_itemViewControllers == nil){
        _itemViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_itemViewControllers addObject:viewController];
}

-(void) removeItemViewController:(id) viewController{
    if([viewController isViewLoaded]){
        [[viewController view] removeFromSuperview];
    }
    [_itemViewControllers removeObject:viewController];
}

-(void) addQueueItemViewController:(id) viewController{
    if([viewController reuseIdentifier]){
        [_queueItemViewControllers addObject:viewController];
    }
}

-(void) removeQueueItemViewController:(id) viewController{
    [_queueItemViewControllers removeObject:viewController];
}

-(void) contentOffsetChanged{
    if(self.window){
        [self layoutItemViews:NO];
        if([self.delegate respondsToSelector:@selector(vtContainerView:didContentOffsetChanged:)]){
            [(id)self.delegate vtContainerView:self didContentOffsetChanged:self.contentOffset];
        }
    }
}

-(void) setContentOffset:(CGPoint)contentOffset{
    if(!CGPointEqualToPoint(self.contentOffset, contentOffset)){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(contentOffsetChanged) object:nil];
        [self performSelectorOnMainThread:@selector(contentOffsetChanged) withObject:nil waitUntilDone:NO];
    }
    [super setContentOffset:contentOffset];
}

-(void) didLayout{
    if([self.delegate respondsToSelector:@selector(vtContainerViewDidLayout:)]){
        [(id)self.delegate vtContainerViewDidLayout:self];
    }
}


-(void) layoutItemViews:(BOOL) reloadData{
    
    NSInteger focusIndex = NSNotFound;
    NSInteger visableFocusIndex = NSNotFound;
    NSInteger fullVisableFocusIndex = NSNotFound;
    
    if(_queueItemViewControllers == nil){
        _queueItemViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    }
    
    NSMutableDictionary * itemViewControllers = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for(VTItemViewController * itemViewController in _itemViewControllers){
        
        NSNumber * key = [NSNumber numberWithLong:itemViewController.index];
        
        id t = [itemViewControllers objectForKey:key];
       
        if(t){
            [itemViewController setDataItem:nil];
            [itemViewController setIndex:NSNotFound];
            [self addQueueItemViewController:t];
            [self removeItemViewController:t];
        }
        
        [itemViewControllers setObject:itemViewController forKey:key];
        
    }
    
    CGSize size = self.bounds.size;
    CGSize contentSize = CGSizeZero;
    CGPoint contentOffset = self.contentOffset;
    CGFloat top = 0;
    CGFloat bottom = 0;
   
    NSInteger index = 0;
    
    if(_backgroundView && _backgroundView.superview == nil){
        
        [_backgroundView setFrame:CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)];
        [_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:_backgroundView];
    }
    
    if(_headerView && _headerView.superview == nil){
        
        CGRect r = _headerView.frame;
        r.origin = CGPointZero;
        r.size.width = size.width;
        top = r.size.height;
        
        [_headerView setFrame:r];
        [_headerView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
        
        [self addSubview:_headerView];

    }
    
    for(NSValue * vRect in [_containerLayout itemRects]){
        
        NSNumber * nKey = [NSNumber numberWithInteger:index];
        
        CGRect rect = [vRect CGRectValue];
        
        rect.origin.y += top;
        
        if(rect.origin.x + rect.size.width  > contentSize.width){
            contentSize.width = rect.origin.x + rect.size.width;
        }
        
        if(rect.origin.y + rect.size.height  > contentSize.height){
            contentSize.height = rect.origin.y + rect.size.height ;
        }
        
        if([self isVisableRect:rect]){
        
            if(visableFocusIndex == NSNotFound){
                visableFocusIndex = index;
            }
            
            if([self isFullVisableRect:rect]){
                if(fullVisableFocusIndex == NSNotFound){
                    fullVisableFocusIndex = index;
                }
            }
            
            if(index == _focusIndex){
                focusIndex = index;
            }

            VTItemViewController * itemViewController = [itemViewControllers objectForKey:nKey];
            if(itemViewController == nil){
                itemViewController = [(id)self.delegate vtContainerView:self itemViewAtIndex:index frame:rect];
            }
            else if(reloadData){
                [itemViewController setDataItem:nil];
                [itemViewController setIndex:NSNotFound];
                [self addQueueItemViewController:itemViewController];
                [self removeItemViewController:itemViewController];
                itemViewController = [(id)self.delegate vtContainerView:self itemViewAtIndex:index frame:rect];
            }
            
            UIView * itemView = [itemViewController view];
            [itemViewController setIndex:index];
            [itemView setFrame:rect];
            
            
            if(itemView.superview == nil){
                [self addItemViewController:itemViewController];
                [self addSubview:itemView];
            }
            
            [self removeQueueItemViewController:itemViewController];
            [itemViewControllers removeObjectForKey:nKey];
        }
        else{
            VTItemViewController * itemViewController = [itemViewControllers objectForKey:nKey];
            if(itemViewController){
                [itemViewController setDataItem:nil];
                [itemViewController setIndex:NSNotFound];
                [self addQueueItemViewController:itemViewController];
                [itemViewControllers removeObjectForKey:nKey];
                [self removeItemViewController:itemViewController];
            }
        }
        
        index ++;
    }
    
    if(_footerView && _footerView.superview == nil){
        CGRect r = _footerView.frame;
        r.origin = CGPointZero;
        r.origin.y = contentSize.height + top;
        r.size.width = size.width;
        bottom = r.size.height;
        
        [_footerView setFrame:r];
        [_footerView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        
        [self addSubview:_footerView];
       
    }
    
    for(VTItemViewController * itemViewController in [itemViewControllers allValues]){
        [itemViewController setDataItem:nil];
        [itemViewController setIndex:NSNotFound];
        [self addQueueItemViewController:itemViewController];
        [self removeItemViewController:itemViewController];
    }
    
    contentSize.height += top +bottom;
    
    if(contentSize.width < size.width){
        contentSize.width = 0;
    }
    
    if(contentSize.height < size.height){
        contentSize.height = 0;
    }
    
    [self setContentSize:contentSize];
  
    if(focusIndex == NSNotFound){
        if(fullVisableFocusIndex != NSNotFound){
            _focusIndex = fullVisableFocusIndex;
            if([self.delegate respondsToSelector:@selector(vtContainerView:didFocusIndexChanged:)]){
                [(id)self.delegate vtContainerView:self didFocusIndexChanged:_focusIndex];
            }
        }
        else if(visableFocusIndex != NSNotFound){
            _focusIndex = visableFocusIndex;
            if([self.delegate respondsToSelector:@selector(vtContainerView:didFocusIndexChanged:)]){
                [(id)self.delegate vtContainerView:self didFocusIndexChanged:_focusIndex];
            }
        }
        else if(_focusIndex != NSNotFound){
            _focusIndex = NSNotFound;
            if([self.delegate respondsToSelector:@selector(vtContainerView:didFocusIndexChanged:)]){
                [(id)self.delegate vtContainerView:self didFocusIndexChanged:_focusIndex];
            }
        }
    }

}


-(void) setHeaderView:(UIView *)headerView{
    if(_headerView != headerView){
        [_headerView removeFromSuperview];
        [_headerView release];
        _headerView = [headerView retain];
        [self layoutItemViews:NO];
    }
}

-(void) setFooterView:(UIView *)footerView{
    if(_footerView != footerView){
        [_footerView removeFromSuperview];
        [_footerView release];
        _footerView = [footerView retain];
        [self layoutItemViews:NO];
    }
}

-(void) setBackgroundView:(UIView *)backgroundView{
    if(_backgroundView != backgroundView){
        [_backgroundView removeFromSuperview];
        [_backgroundView release];
        _backgroundView = [backgroundView retain];
        [self layoutItemViews:NO];
    }
}



-(BOOL) isVisableRect:(CGRect) frame{
    CGRect rect = self.bounds;
    rect.origin = self.contentOffset;
    rect.origin.x -= _visableEdgeInsets.left;
    rect.origin.y -= _visableEdgeInsets.top;
    rect.size.width += _visableEdgeInsets.left + _visableEdgeInsets.right;
    rect.size.height += _visableEdgeInsets.top + _visableEdgeInsets.bottom;
    
    CGRect rs = CGRectIntersection(rect, frame);
    return rs.size.width >0 && rs.size.height > 0;
}

-(BOOL) isFullVisableRect:(CGRect) frame{
    CGRect rect = self.bounds;
    rect.origin = self.contentOffset;
    rect.origin.x -= _visableEdgeInsets.left;
    rect.origin.y -= _visableEdgeInsets.top;
    rect.size.width += _visableEdgeInsets.left + _visableEdgeInsets.right;
    rect.size.height += _visableEdgeInsets.top + _visableEdgeInsets.bottom;
    
    CGRect rs = CGRectIntersection(rect, frame);
    return CGSizeEqualToSize(frame.size, rs.size);
}

-(VTItemViewController *) dequeueReusableItemViewWithIdentifier:(NSString * )reuseIdentifier{
    for(VTItemViewController * itemViewController in _queueItemViewControllers){
        if(reuseIdentifier == itemViewController.reuseIdentifier || [reuseIdentifier isEqualToString:itemViewController.reuseIdentifier]){
            return itemViewController;
        }
    }
    return nil;
}

-(void) reloadData{
    [_containerLayout setSize:[self innerSize]];
    [_containerLayout reloadData];
    
    if([self.delegate respondsToSelector:@selector(vtContainerViewWillLayout:)]){
        [(id)self.delegate vtContainerViewWillLayout:self];
    }
    
    [self layoutItemViews:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didLayout) object:nil];
    [self performSelector:@selector(didLayout) withObject:nil afterDelay:0.0];
}

-(void) relayout{
    [_containerLayout setSize:[self innerSize]];
    [_containerLayout reloadData];
    if([self.delegate respondsToSelector:@selector(vtContainerViewWillLayout:)]){
        [(id)self.delegate vtContainerViewWillLayout:self];
    }
    [self layoutItemViews:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didLayout) object:nil];
    [self performSelector:@selector(didLayout) withObject:nil afterDelay:0.0];
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(!CGSizeEqualToSize(_containerLayout.size, self.bounds.size)){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayout) object:nil];
        [self performSelector:@selector(relayout) withObject:nil afterDelay:0.0];
    }
}

-(CGRect) itemRectAtIndex:(NSInteger) index{
    return [_containerLayout itemRectAtIndex:index];
}

-(void) setFocusIndex:(NSInteger)focusIndex animated:(BOOL) animated{
    _focusIndex = focusIndex;
    if(_focusIndex != NSNotFound){
        CGRect r = [_containerLayout itemRectAtIndex:_focusIndex];
        if(!CGRectEqualToRect(r, CGRectZero)){
            [self scrollRectToVisible:r animated:animated];
            if(!animated){
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didLayout) object:nil];
                [self performSelectorOnMainThread:@selector(didLayout) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

-(void) setFocusIndex:(NSInteger)focuseIndex{
    [self setFocusIndex:focuseIndex animated:NO];
}

-(VTItemViewController *) itemViewControllerAtIndex:(NSInteger) index{
    for(id viewController in _itemViewControllers){
        if([viewController index] == index){
            return viewController;
        }
    }
    return nil;
}

-(CGSize) innerSize{
    UIEdgeInsets insets = self.contentInset;
    CGSize size = self.bounds.size;
    return CGSizeMake(size.width - insets.left - insets.right, size.height - insets.top - insets.bottom);
}

-(NSArray *) visableItemViewControllers{
    if(_itemViewControllers){
        return [NSArray arrayWithArray:_itemViewControllers];
    }
    return nil;
}

@end
