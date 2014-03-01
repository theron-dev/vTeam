//
//  VTPageDataController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-5-4.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTPageDataController.h"

#import "VTPageDataSource.h"

@interface VTPageDataController(){
    BOOL _allowLeftAction;
    BOOL _allowRightAction;
}

@end

@implementation VTPageDataController

@synthesize containerView = _containerView;
@synthesize itemViewNib = _itemViewNib;
@synthesize leftLoadingView = _leftLoadingView;
@synthesize rightLoadingView = _rightLoadingView;
@synthesize itemViewClass = _itemViewClass;
@synthesize itemViewBundle = _itemViewBundle;

-(void) dealloc{
    [_containerView setDelegate:nil];
    [_itemViewNib release];
    [_leftLoadingView release];
    [_rightLoadingView release];
    [_containerView release];
    [_itemViewClass release];
    [_itemViewBundle release];
    [super dealloc];
}

-(NSInteger) pageIndex{
    
    CGSize size = _containerView.bounds.size;
    CGSize contentSize = _containerView.contentSize;
    CGPoint contentOffset = _containerView.contentOffset;
    
    NSInteger pageIndex = contentOffset.x / size.width;
    
    
    if(contentSize.width < size.width){
        contentSize.width = size.width;
    }
    
    NSInteger pageCount = contentSize.width / size.width;
    
    if(pageIndex >= pageCount ){
        pageIndex = pageCount -1;
    }
    
    if(pageIndex < 0){
        pageIndex = 0;
    }
    
    return pageIndex;
}

-(void) setPageIndex:(NSInteger)pageIndex animated:(BOOL) animated{
    CGSize size = _containerView.bounds.size;
    [_containerView setContentOffset:CGPointMake(pageIndex * size.width, 0) animated:animated];
    if(!animated){
        [_pageControl setCurrentPage:pageIndex];
    }
}

-(NSInteger) pageCount{
    
    CGSize size = _containerView.bounds.size;
    CGSize contentSize = _containerView.contentSize;

    if(contentSize.width < size.width){
        contentSize.width = size.width;
    }
    
    return contentSize.width / size.width;
}

-(NSInteger) numberOfVTContainerLayout:(VTContainerLayout *) containerLayout{
    NSInteger pageCount = [self.dataSource count];
    [_pageControl setNumberOfPages:pageCount];
    return pageCount;
}

-(CGSize) vtContainerLayout:(VTContainerLayout *) containerLayout itemSizeAtIndex:(NSInteger) index{
    return containerLayout.size;
}

-(VTItemViewController *) vtContainerView:(VTContainerView *) containerView itemViewAtIndex:(NSInteger) index frame:(CGRect) frame{
    
    VTItemViewController * itemViewController = [containerView dequeueReusableItemViewWithIdentifier:@"ItemView"];
    
    if(itemViewController == nil){
        
        Class clazz = NSClassFromString(_itemViewClass);
        
        if(clazz == nil){
            clazz = [VTItemViewController class];
        }
        
        itemViewController = [[[clazz alloc] initWithNibName:_itemViewNib bundle:_itemViewBundle] autorelease];
        [itemViewController setReuseIdentifier:@"ItemView"];
        [itemViewController setDelegate:self];
    }
    
    id data = [self.dataSource dataObjectAtIndex:index];
    
    UIView * itemView = [itemViewController view];
    
    [itemViewController setContext:self.context];
    
    [itemViewController setDataItem:data];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(downloadImagesForView:) object:itemView];
    
    [self performSelectorOnMainThread:@selector(downloadImagesForView:) withObject:itemView waitUntilDone:NO];
    
    return itemViewController;
}

-(void) vtDataSourceWillLoading:(VTDataSource *)dataSource{
    [self startLoading];
    [super vtDataSourceWillLoading:dataSource];
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [super vtDataSourceDidLoadedFromCache:dataSource timestamp:timestamp];
    [_containerView reloadData];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [super vtDataSourceDidLoaded:dataSource];
    if([dataSource isDataChanged]){
        [_containerView reloadData];
    }
    [self stopLoading];
}

-(void) vtDataSource:(VTDataSource *)dataSource didFitalError:(NSError *)error{
    [self stopLoading];
    [super vtDataSource:dataSource didFitalError:error];
}

-(void) resetLoading{
    
    CGSize size = _containerView.bounds.size;
    CGSize contentSize = _containerView.contentSize;
    
    if(_leftLoadingView && (![self.delegate respondsToSelector:@selector(vtPageDataControllerShowLeftLoading:)]
                            || [self.delegate vtPageDataControllerShowLeftLoading:self])){
        CGRect r = _leftLoadingView.frame;
        r.size.height = size.height;
        r.origin.y = 0;
        r.origin.x = - r.size.width;
        [_leftLoadingView setFrame:r];
        [_leftLoadingView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        [_leftLoadingView setDirect:VTDragLoadingViewDirectRight];
        if(_leftLoadingView.superview != _containerView){
            [_containerView addSubview:_leftLoadingView];
        }
    }
    else{
        [_leftLoadingView removeFromSuperview];
    }
    
    if(_rightLoadingView && contentSize.width >= size.width &&  (![self.delegate respondsToSelector:@selector(vtPageDataControllerShowRightLoading:)]
                            || [self.delegate vtPageDataControllerShowRightLoading:self])){
        CGRect r = _rightLoadingView.frame;
        r.size.height = size.height;
        r.origin.y = 0;
        r.origin.x = contentSize.width;
        [_rightLoadingView setFrame:r];
        [_rightLoadingView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
        [_rightLoadingView setDirect:VTDragLoadingViewDirectLeft];
        if(_rightLoadingView.superview != _containerView){
            [_containerView addSubview:_rightLoadingView];
        }
    }
    else{
        [_rightLoadingView removeFromSuperview];
    }
}

-(void) startLoading{
    
    
    [self resetLoading];
    [_leftLoadingView startAnimation];
    [_rightLoadingView startAnimation];
    
}

-(void) stopLoading{
    
    [self resetLoading];
    [_leftLoadingView stopAnimation];
    [_rightLoadingView stopAnimation];
}

-(void) vtContainerView:(VTContainerView *)containerView didContentOffsetChanged:(CGPoint)contentOffset{
    CGSize contentSize = containerView.contentSize;
    CGSize size = containerView.bounds.size;
    
    if(![_leftLoadingView isAnimating] && ![_rightLoadingView isAnimating]){
       
        if(contentOffset.x < 0){
            if( - contentOffset.x >= _leftLoadingView.frame.size.width){
                [_leftLoadingView setDirect:VTDragLoadingViewDirectLeft];
            }
            else{
                [_leftLoadingView setDirect:VTDragLoadingViewDirectRight];
                if(_allowLeftAction){
                    _allowLeftAction = NO;
                    if([self.delegate respondsToSelector:@selector(vtPageDataControllerLeftAction:)]){
                        [self.delegate vtPageDataControllerLeftAction:self];
                    }
                }
            }
        }
        else if(contentOffset.x + size.width > contentSize.width){
            if( contentOffset.x + size.width > contentSize.width + _rightLoadingView.frame.size.width){
                [_rightLoadingView setDirect:VTDragLoadingViewDirectRight];
            }
            else{
                [_rightLoadingView setDirect:VTDragLoadingViewDirectLeft];
                if(_allowRightAction){
                    _allowRightAction = NO;
                    if([self.delegate respondsToSelector:@selector(vtPageDataControllerRightAction:)]){
                        [self.delegate vtPageDataControllerRightAction:self];
                    }
                }
            }
        }
    }
    
}



-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //[self downloadImagesForView:scrollView];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate){
        if(![_leftLoadingView isAnimating] && ![_rightLoadingView isAnimating]){
            CGPoint contentOffset = scrollView.contentOffset;
            CGSize contentSize = scrollView.contentSize;
            CGSize size = scrollView.bounds.size;
            
            if(_leftLoadingView.superview && - contentOffset.x >= _leftLoadingView.frame.size.width){
                _allowLeftAction = YES;
            }
            else if(_rightLoadingView.superview
                    && contentOffset.x - contentSize.width + size.width >= - _rightLoadingView.frame.size.height){
                _allowRightAction = YES;
            }
        }
    }
    else{
        //[self downloadImagesForView:scrollView];
    }

}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //[self downloadImagesForView:scrollView];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_pageControl setCurrentPage:self.pageIndex];
}

-(void) vtItemViewController:(VTItemViewController *) itemViewController doAction:(id) action{
    if([self.delegate respondsToSelector:@selector(vtPageDataController:itemViewController:doAction:)]){
        [self.delegate vtPageDataController:self
                              itemViewController:itemViewController doAction:action];
    }
}

-(void) vtContainerViewDidLayout:(VTContainerView *) containerView{
    //[self downloadImagesForView:containerView];
}

-(void) cancel{
    [super cancel];
    [self stopLoading];
}

-(void) vtContainerView:(VTContainerView *)containerView didFocusIndexChanged:(NSInteger)focusIndex{
    if([self.delegate respondsToSelector:@selector(vtPageDataController:focusIndexChanged:)]){
        [self.delegate vtPageDataController:self focusIndexChanged:focusIndex];
    }
}

@end
