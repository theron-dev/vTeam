//
//  VTTableDataController.m
//  vTeam
//
//  Created by Zhang Hailong on 13-7-6.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTableDataController.h"

#import "VTPageDataSource.h"
#import "VTTableViewCell.h"

@interface VTTableDataController(){
    BOOL _allowRefresh;
    NSDateFormatter * _dateFormatter;
    CGPoint _preContentOffset;
    BOOL _animating;
}

@property(nonatomic,readonly) NSDateFormatter * dateFormatter;

@end


@implementation VTTableDataController


@synthesize tableView = _tableView;
@synthesize itemViewNib = _itemViewNib;
@synthesize topLoadingView = _topLoadingView;
@synthesize bottomLoadingView = _bottomLoadingView;
@synthesize notFoundDataView = _notFoundDataView;
@synthesize autoHiddenViews = _autoHiddenViews;
@synthesize itemViewBundle = _itemViewBundle;
@synthesize headerCells = _headerCells;
@synthesize footerCells = _footerCells;
@synthesize reusableCellIdentifier = _reusableCellIdentifier;

-(void) dealloc{
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    [_itemViewNib release];
    [_topLoadingView release];
    [_bottomLoadingView release];
    [_notFoundDataView release];
    [_dateFormatter release];
    [_tableView release];
    [_autoHiddenViews release];
    [_itemViewBundle release];
    [_headerCells release];
    [_footerCells release];
    [_reusableCellIdentifier release];
    [super dealloc];
}

-(NSDateFormatter *) dateFormatter{
    if(_dateFormatter == nil){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [_headerCells count]){
        return [[_headerCells objectAtIndex:indexPath.row] frame].size.height;
    }
    
    if(indexPath.row >= [self.dataSource count] + [_headerCells count]){
        return [[_footerCells objectAtIndex:indexPath.row
                - [self.dataSource count] - [_headerCells count]] frame].size.height;
    }
    
    return tableView.rowHeight;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.dataSource count] >0){
        return [self.dataSource count] + [_headerCells count] + [_footerCells count];
    }
    return 0;
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
                    [dateFormatter setDateFormat:@"最后更新: HH:mm:ss"];
                    text = [dateFormatter stringFromDate:date];
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

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row < [_headerCells count]){
        return [_headerCells objectAtIndex:indexPath.row];
    }
    
    if(indexPath.row >= [self.dataSource count] + [_headerCells count]){
        return [_footerCells objectAtIndex:indexPath.row
                - [self.dataSource count] - [_headerCells count]];
    }
    
    NSString * identifier = _reusableCellIdentifier;
    
    if(identifier == nil){
        identifier = @"Cell";
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        cell = (UITableViewCell *) [VTTableViewCell tableViewCellWithNibName:_itemViewNib bundle:_itemViewBundle];
        
        [cell setValue:identifier forKey:@"reuseIdentifier"];
        
        if([cell isKindOfClass:[VTTableViewCell class]]){
            [(VTTableViewCell *) cell setController:self];
            [(VTTableViewCell *) cell setDelegate:self];
        }
    }
    
    id data = [self.dataSource dataObjectAtIndex:indexPath.row - [_headerCells count]];
    
    if([cell isKindOfClass:[VTTableViewCell class]]){
        [(VTTableViewCell *) cell setContext:self.context];
        [(VTTableViewCell *) cell setDataItem:data];
    }
    
    
    return cell;
}


-(void) vtDataSourceWillLoading:(VTDataSource *)dataSource{
    [_notFoundDataView removeFromSuperview];
    [self startLoading];
    [super vtDataSourceWillLoading:dataSource];
}

-(void) vtDataSourceDidLoadedFromCache:(VTDataSource *) dataSource timestamp:(NSDate *) timestamp{
    [super vtDataSourceDidLoadedFromCache:dataSource timestamp:timestamp];
    [self setLastUpdateDate:timestamp];
    [_tableView reloadData];
}

-(void) vtDataSourceDidLoaded:(VTDataSource *) dataSource{
    [super vtDataSourceDidLoaded:dataSource];
    [self setLastUpdateDate:[NSDate date]];
    [_tableView reloadData];
    [self stopLoading];
}

-(void) vtDataSourceDidContentChanged:(VTDataSource *)dataSource{
    [super vtDataSourceDidContentChanged:dataSource];
    [_tableView reloadData];
}

-(void) vtDataSource:(VTDataSource *)dataSource didFitalError:(NSError *)error{
    [self stopLoading];
    [super vtDataSource:dataSource didFitalError:error];
}

-(void) startLoading{
    
    if(![(id)self.dataSource respondsToSelector:@selector(pageIndex)]
       || [(id)self.dataSource pageIndex] == 1){
       
        CGRect r = _topLoadingView.frame;
        
        r.size.width = _tableView.bounds.size.width;
        r.origin.y = - r.size.height;
        
        [_topLoadingView setFrame:r];
        
        if(_topLoadingView.superview == nil){
            [_tableView addSubview:_topLoadingView];
        }
        
        if(_tableView.contentOffset.y < _topLoadingView.frame.size.height){
            
            [_tableView setContentOffset:CGPointMake(0, - r.size.height - _tableView.contentInset.top) animated:NO];
            
        }
        
        [_tableView setTableFooterView:nil];
    }
    else{
        [_tableView setTableFooterView:nil];
        [_tableView setTableFooterView:_bottomLoadingView];
    }
    
    [_topLoadingView startAnimation];
    [_bottomLoadingView startAnimation];
    
}

-(void) stopLoading{
    


    [_tableView setTableFooterView:nil];
    
    [_bottomLoadingView removeFromSuperview];
    
    [_topLoadingView stopAnimation];
    [_bottomLoadingView stopAnimation];


    
    if(_topLoadingView && _topLoadingView.superview == nil){
        
        CGRect r = _topLoadingView.frame;
        
        r.size.width = _tableView.bounds.size.width;
        r.origin.y = - r.size.height;
        
        [_topLoadingView setFrame:r];
        if(_topLoadingView.superview == nil){
            [_tableView addSubview:_topLoadingView];
        }
    }
    
    if(_tableView.contentOffset.y < _tableView.contentInset.top){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top) animated:NO];
        [UIView commitAnimations];
    }
    
    if([self.dataSource respondsToSelector:@selector(hasMoreData)]
       && [(id)self.dataSource hasMoreData]){
        
        CGSize contentSize = _tableView.contentSize;
        
        if(_bottomLoadingView && _bottomLoadingView.superview == nil
           && contentSize.height >= _tableView.bounds.size.height){
            
            CGRect r = _bottomLoadingView.frame;
            
            r.size.width = _tableView.bounds.size.width;
            r.origin.y = contentSize.height;
            
            [_bottomLoadingView setFrame:r];
            [_tableView addSubview:_bottomLoadingView];
            
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
            _notFoundDataView.frame = _tableView.bounds;
            [_notFoundDataView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
            [_tableView addSubview:_notFoundDataView];
        }
    }
    else{
        [_notFoundDataView removeFromSuperview];
    }

}

-(void) tableView:(UITableView *)tableView didContentOffsetChanged:(CGPoint)contentOffset{
    
    if(_animating){
        return;
    }
    
    CGSize contentSize = tableView.contentSize;
    UIEdgeInsets contentInset = tableView.contentInset;
    CGSize size = tableView.bounds.size;
    
    if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating]){
        if(contentOffset.y < -contentInset.top){
            if( - (contentOffset.y + contentInset.top) >= _topLoadingView.frame.size.height){
                [_topLoadingView setDirect:VTDragLoadingViewDirectUp];
            }
            else{
                [_topLoadingView setDirect:VTDragLoadingViewDirectDown];
                if(_allowRefresh){
                    [self refreshData];
                    _allowRefresh = NO;
                }
            }
            CGRect r = _topLoadingView.frame;
            
            r.size.width = size.width;
            r.origin.y = - r.size.height;
            
            [_topLoadingView setFrame:r];
            
            if(_topLoadingView.superview == nil){
                [tableView addSubview:_topLoadingView];
                [tableView sendSubviewToBack:_topLoadingView];
            }
        }
        else if(contentOffset.y  + size.height > contentSize.height){
            [_bottomLoadingView setDirect:VTDragLoadingViewDirectUp];
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

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(![_topLoadingView isAnimating] && ![_bottomLoadingView isAnimating] && _bottomLoadingView.superview
       && [self.dataSource respondsToSelector:@selector(hasMoreData)] && [(id)self.dataSource hasMoreData]
       && scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.frame.size.height > - _bottomLoadingView.frame.size.height
       && ![self.dataSource isLoading]){
        [(id)self.dataSource performSelectorOnMainThread:@selector(loadMoreData) withObject:nil waitUntilDone:NO];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate){
        if(![_topLoadingView isAnimating]){
            if(- scrollView.contentOffset.y >= _topLoadingView.frame.size.height){
                _allowRefresh = YES;
            }
            else if(_bottomLoadingView.superview
                    && [self.dataSource respondsToSelector:@selector(hasMoreData)] && [(id)self.dataSource hasMoreData]
                    && scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.frame.size.height > -_bottomLoadingView.frame.size.height
                    && ![self.dataSource isLoading]){
                [self.dataSource performSelectorOnMainThread:@selector(loadMoreData) withObject:nil waitUntilDone:NO];
            }
        }
    }
}

-(void) vtTableViewCell:(VTTableViewCell *) tableViewCell doAction:(id) action{
    if([self.delegate respondsToSelector:@selector(vtTableDataController:cell:doAction:)]){
        [self.delegate vtTableDataController:self cell:tableViewCell doAction:action];
    }
}

-(void) cancel{
    [super cancel];
    [self stopLoading];
}

-(id) dataObjectForIndexPath:(NSIndexPath *) indexPath{
    
    if(indexPath.row < [_headerCells count]){
        return nil;
    }
    
    if(indexPath.row >= [self.dataSource count] + [_headerCells count]){
        return nil;
    }

    return [self.dataSource dataObjectAtIndex:indexPath.row - [_headerCells count]];
}

@end
