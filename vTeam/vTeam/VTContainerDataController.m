//
//  VTContainerDataController.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTContainerDataController.h"

#import "VTPageDataSource.h"

@interface VTContainerDataController(){
    BOOL _allowRefresh;
    NSDateFormatter * _dateFormatter;
    CGPoint _preContentOffset;
}

@property(nonatomic,readonly) NSDateFormatter * dateFormatter;

@end

@implementation VTContainerDataController

@synthesize containerView = _containerView;
@synthesize itemViewNib = _itemViewNib;
@synthesize topLoadingView = _topLoadingView;
@synthesize bottomLoadingView = _bottomLoadingView;
@synthesize notFoundDataView = _notFoundDataView;
@synthesize autoHiddenViews = _autoHiddenViews;
@synthesize itemViewClass = _itemViewClass;
@synthesize itemViewBundle = _itemViewBundle;
@synthesize itemSize = _itemSize;
@synthesize headerItemViewControllers = _headerItemViewControllers;
@synthesize footerItemViewControllers = _footerItemViewControllers;

-(void) dealloc{
    [_headerItemViewControllers release];
    [_footerItemViewControllers release];
    [_containerView setDelegate:nil];
    [_itemViewNib release];
    [_topLoadingView release];
    [_bottomLoadingView release];
    [_notFoundDataView release];
    [_dateFormatter release];
    [_containerView release];
    [_autoHiddenViews release];
    [_itemViewClass release];
    [_itemViewBundle release];
    [super dealloc];
}

-(NSDateFormatter *) dateFormatter{
    if(_dateFormatter == nil){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

-(NSInteger) numberOfVTContainerLayout:(VTContainerLayout *) containerLayout{
    return [self.dataSource count] + [_headerItemViewControllers count] + [_footerItemViewControllers count];
}

-(void) setLastUpdateDate:(NSDate *)date{
    if(date){
        
        NSDateFormatter * dateFormatter = [self dateFormatter];
        
        NSString * text = nil;
        NSDate * now = [NSDate date];
        
        int unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents * timeComponents = [[NSCalendar currentCalendar] components:unit fromDate:date];
        NSDateComponents * nowComponents = [[NSCalendar currentCalendar] components:unit fromDate:now];
        
        if(timeComponents.year == nowComponents.year){
            if(timeComponents.month == nowComponents.month){
                if(timeComponents.day == nowComponents.day){
                    
                    NSTimeInterval d = [now timeIntervalSince1970] - [date timeIntervalSince1970];
                    
                    if(d < 60){
                        text = [NSString stringWithFormat:@"最后更新: 刚刚"];
                    }
                    else if(d < 3600){
                        text = [NSString stringWithFormat:@"最后更新: %d分钟前",(int)d / 60];
                    }
                    else{
                        [dateFormatter setDateFormat:@"最后更新: HH:mm"];
                        text = [dateFormatter stringFromDate:date];
                    }
                }
                else if(timeComponents.day +1 == nowComponents.day){
                    [dateFormatter setDateFormat:@"最后更新: 昨天 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
                else if(timeComponents.day -1 == nowComponents.day){
                    [dateFormatter setDateFormat:@"最后更新: 明天 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
                else {
                    [dateFormatter setDateFormat:@"最后更新: MM月dd日 HH:mm"];
                    text = [dateFormatter stringFromDate:date];
                }
            }
            else{
                [dateFormatter setDateFormat:@"最后更新: MM月dd日 HH:mm"];
                text = [dateFormatter stringFromDate:date];
            }
        }
        else{
            [dateFormatter setDateFormat:@"最后更新: yyyy年MM月dd日 HH:mm"];
            text = [dateFormatter stringFromDate:date];
        }
        
        [_topLoadingView.timeLabel setText:text];
        [_bottomLoadingView.timeLabel setText:text];
    }
    else{
        [_topLoadingView.timeLabel setText:@""];
        [_bottomLoadingView.timeLabel setText:@""];
    }
}


-(VTItemViewController *) vtContainerView:(VTContainerView *) containerView itemViewAtIndex:(NSInteger) index frame:(CGRect) frame{
    
    if(index < [_headerItemViewControllers count]){
        
        VTItemViewController * itemViewController = [_headerItemViewControllers objectAtIndex:index];
        
        if([itemViewController reuseIdentifier] == nil){
            [itemViewController setReuseIdentifier:@"HeaderItemView"];
        }
        
        [itemViewController setDelegate:self];
        [itemViewController setContext:self.context];
        [itemViewController view];
        [itemViewController setDataItem:nil];
        
        return itemViewController;
    }
    else {
        index -= [_headerItemViewControllers count];
    }
    
    if(index < [self.dataSource count]){
    
        NSString * reseIdentifier = self.reseIdentifier;
        
        if(reseIdentifier == nil){
            reseIdentifier = _itemViewNib;
        }
        
        if(reseIdentifier == nil){
            reseIdentifier = @"ItemView";
        }
        
        VTItemViewController * itemViewController = [containerView dequeueReusableItemViewWithIdentifier:reseIdentifier];
        
        if(itemViewController == nil){
            
            Class clazz = NSClassFromString(_itemViewClass);
            
            if(clazz == nil){
                clazz = [VTItemViewController class];
            }
            
            
            
            itemViewController = [[[clazz alloc] initWithNibName:_itemViewNib bundle:_itemViewBundle] autorelease];
            [itemViewController setReuseIdentifier:reseIdentifier];
            [itemViewController setDelegate:self];
        }
        
        id data = [self dataObjectByIndexPath:[NSIndexPath indexPathForRow:index + [self.headerItemViewControllers count] inSection:0]];
        
        [itemViewController setContext:self.context];
        
        [itemViewController view];

        [itemViewController setDataItem:data];
        
        return itemViewController;
    }
    else{
        index -= [self.dataSource count];
    }
    
    if(index < [_footerItemViewControllers count]){
        
        VTItemViewController * itemViewController = [_headerItemViewControllers objectAtIndex:index];
        
        if(itemViewController.restorationIdentifier == nil){
            [itemViewController setReuseIdentifier:@"FooterItemView"];
        }
        
        [itemViewController setDelegate:self];
        [itemViewController setContext:self.context];
        [itemViewController view];
        [itemViewController setDataItem:nil];
        
        return itemViewController;
    }
    
    return nil;
}

-(void) vtDataSourceWillLoading:(VTDataSource *)dataSource{
    [_notFoundDataView removeFromSuperview];
    [self startLoading];
    [super vtDataSourceWillLoading:dataSource];
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [super vtDataSourceDidLoadedFromCache:dataSource timestamp:timestamp];
    [self setLastUpdateDate:timestamp];
    [_containerView reloadData];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [super vtDataSourceDidLoaded:dataSource];
    [self setLastUpdateDate:[NSDate date]];
    if([dataSource isDataChanged]){
        [_containerView reloadData];
    }
    [self stopLoading];
}

-(void) vtDataSource:(VTDataSource *)dataSource didFitalError:(NSError *)error{
    [self stopLoading];
    [super vtDataSource:dataSource didFitalError:error];
}


-(void) startLoading{
    
    [_bottomLoadingView removeFromSuperview];
    [_topLoadingView removeFromSuperview];
    
    if(![(id)self.dataSource respondsToSelector:@selector(pageIndex)]
       || [(id)self.dataSource pageIndex] == 1){
        [_containerView setHeaderView:_topLoadingView];
        [_containerView setFooterView:nil];
    }
    else{        
        [_containerView setFooterView:_bottomLoadingView];
        [_containerView setHeaderView:nil];
    }
    
    [_topLoadingView startAnimation];
    [_bottomLoadingView startAnimation];
    
}

-(void) stopLoading{
    
    [_containerView setHeaderView:nil];
    [_containerView setFooterView:nil];

    
    [_topLoadingView removeFromSuperview];
    [_bottomLoadingView removeFromSuperview];
    
    
    [_topLoadingView stopAnimation];
    [_bottomLoadingView stopAnimation];
    
    if(_topLoadingView && _topLoadingView.superview == nil){
        
        CGRect r = _topLoadingView.frame;
        
        r.size.width = _containerView.bounds.size.width;
        r.origin.y = - r.size.height;
        
        [_topLoadingView setFrame:r];
        [_containerView addSubview:_topLoadingView];
    }
    
    if([self.dataSource respondsToSelector:@selector(hasMoreData)]
       && [(id)self.dataSource hasMoreData]){
        
        CGSize contentSize = _containerView.contentSize;
        
        if(_bottomLoadingView && _bottomLoadingView.superview == nil
           && contentSize.height >= _containerView.bounds.size.height){
            
            CGRect r = _bottomLoadingView.frame;
            
            r.size.width = _containerView.bounds.size.width;
            r.origin.y = contentSize.height;
            
            [_bottomLoadingView setFrame:r];
            [_containerView addSubview:_bottomLoadingView];
            
        }
        else{
            [_bottomLoadingView removeFromSuperview];
        }
    }
    else{
        [_bottomLoadingView removeFromSuperview];
    }
    
    if([self.dataSource isEmpty]){
        if(_notFoundDataView && _notFoundDataView.superview == nil){
            _notFoundDataView.frame = _containerView.bounds;
            [_notFoundDataView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [_containerView addSubview:_notFoundDataView];
        }
    }
    else{
        [_notFoundDataView removeFromSuperview];
    }
    
}

-(void) vtContainerView:(VTContainerView *)containerView didContentOffsetChanged:(CGPoint)contentOffset{
    CGSize contentSize = containerView.contentSize;
    UIEdgeInsets contentInset = containerView.contentInset;
    CGSize size = containerView.bounds.size;
    
    if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating]){
        if(contentOffset.y < -contentInset.top){
            if( - (contentOffset.y + contentInset.top) >= _topLoadingView.frame.size.height){
                [_topLoadingView setDirect:VTDragLoadingViewDirectUp];
            }
            else{
                [_topLoadingView setDirect:VTDragLoadingViewDirectDown];
                if(_allowRefresh){
                    [self.dataSource reloadData];
                    _allowRefresh = NO;
                }
            }
            CGRect r = _topLoadingView.frame;
            
            r.size.width = size.width;
            r.origin.y = - r.size.height;
            
            [_topLoadingView setFrame:r];
            
            if(_topLoadingView.superview == nil){
                [containerView addSubview:_topLoadingView];
                [containerView sendSubviewToBack:_topLoadingView];
            }
        }
        else if(contentOffset.y  + size.height > contentSize.height){
            [_bottomLoadingView setDirect:VTDragLoadingViewDirectUp];
            [_topLoadingView removeFromSuperview];
        }
        else{
            [_topLoadingView removeFromSuperview];
        }
    }
    
    if(contentOffset.y > -contentInset.top && contentOffset.y + size.height < contentSize.height
       && !CGPointEqualToPoint(_preContentOffset, contentOffset)){
        
        CGFloat dy = contentOffset.y - _preContentOffset.y;
        
        if(dy >0){
            
            CGFloat alpha = [[_autoHiddenViews lastObject] alpha] - 0.05;
            
            if(alpha < 0.0f){
                alpha = 0.0f;
            }
            
            for(UIView * v in _autoHiddenViews){
                [v setAlpha:alpha];
                [v setHidden:alpha == 0.0];
            }
            
        }
        else if(dy <0){
            
            CGFloat alpha = [[_autoHiddenViews lastObject] alpha] + 0.05;
            
            if(alpha > 1.0f){
                alpha = 1.0f;
            }
            
            for(UIView * v in _autoHiddenViews){
                [v setAlpha:alpha];
                [v setHidden:alpha == 0.0];
            }
            
        }
        
        _preContentOffset = contentOffset;
    }
    else if(contentOffset.y <= -contentInset.top){
        for(UIView * v in _autoHiddenViews){
            [v setAlpha:1.0];
            [v setHidden:NO];
        }
    }
    
    
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating] && _bottomLoadingView.superview
       && [self.dataSource respondsToSelector:@selector(hasMoreData)] && [(id)self.dataSource hasMoreData]
       && scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.frame.size.height > - _bottomLoadingView.frame.size.height){
        [(id)self.dataSource performSelectorOnMainThread:@selector(loadMoreData) withObject:nil waitUntilDone:NO];
    }

}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){

        if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating] && _bottomLoadingView.superview
           && [self.dataSource respondsToSelector:@selector(hasMoreData)] && [(id)self.dataSource hasMoreData]
           && scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.frame.size.height > -_bottomLoadingView.frame.size.height){
            [self.dataSource performSelectorOnMainThread:@selector(loadMoreData) withObject:nil waitUntilDone:NO];
        }
    }
    else{
        if(![_topLoadingView isAnimating]){
            if(- scrollView.contentOffset.y >= _topLoadingView.frame.size.height){
                _allowRefresh = YES;
            }
            else if(_bottomLoadingView.superview
                    && [self.dataSource respondsToSelector:@selector(hasMoreData)] && [(id)self.dataSource hasMoreData]
                    && scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.frame.size.height > -_bottomLoadingView.frame.size.height){
                [self.dataSource performSelectorOnMainThread:@selector(loadMoreData) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

-(void) vtItemViewController:(VTItemViewController *) itemViewController doAction:(id) action{
    if([self.delegate respondsToSelector:@selector(vtContainerDataController:itemViewController:doAction:)]){
        [self.delegate vtContainerDataController:self
                              itemViewController:itemViewController doAction:action];
    }
}

-(void) vtContainerViewDidLayout:(VTContainerView *) containerView{

}

-(CGSize) vtContainerLayout:(VTContainerLayout *)containerLayout itemSizeAtIndex:(NSInteger)index{
    
    if(index < [_headerItemViewControllers count]){
        
        VTItemViewController * itemViewController = [_headerItemViewControllers objectAtIndex:index];
        
        return [itemViewController itemSize];
    }
    else{
        index -= [_headerItemViewControllers count];
    }
    
    if(index < [self.dataSource count]){
        return _itemSize;
    }
    else{
        index -= [self.dataSource count];
    }
    
    if(index < [_footerItemViewControllers count]){
        
        VTItemViewController * itemViewController = [_footerItemViewControllers objectAtIndex:index];
        
        return [itemViewController itemSize];
    }
    
    return _itemSize;
}

-(BOOL) vtFallsContainerLayout:(VTFallsContainerLayout *) containerLayout isFillWidthAtIndex:(NSInteger) index{
    
    if(index < [_headerItemViewControllers count]){
        
        return YES;
    }
    else {
        index -= [_headerItemViewControllers count];
    }
    
    if(index < [self.dataSource count]){
        return NO;
    }
    else{
        index -= [self.dataSource count];
    }
    
    if(index < [_footerItemViewControllers count]){
        return YES;
    }
    
    return NO;
}


-(void) cancel{
    [super cancel];
    [self stopLoading];
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *) dataSource{
    [super vtDataSourceDidLoaded:dataSource];
    if(self.dataSource == dataSource){
        [_containerView reloadData];
    }
}

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath{
    return [self.dataSource dataObjectAtIndex:indexPath.row - [self.headerItemViewControllers count]];
}

@end
