//
//  VTTabPageDataController.m
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabPageDataController.h"

@interface VTTabPageDataController(){
    BOOL _animating;
}

@end

@implementation VTTabPageDataController

@synthesize pageContentView = _pageContentView;
@synthesize tabBackgroundView = _tabBackgroundView;
@synthesize leftSpaceWidth = _leftSpaceWidth;
@synthesize rightSpaceWidth = _rightSpaceWidth;

-(void) dealloc{
    [_pageContentView setDelegate:nil];
    [_pageContentView release];
    [_tabBackgroundView release];
    [super dealloc];
}

-(void) scrollToTabBackgroundVisable:(BOOL) animated{
    if([_tabBackgroundView.superview isKindOfClass:[UIScrollView class]]){
        UIScrollView * scrollView = (UIScrollView *) _tabBackgroundView.superview;
        CGPoint contentOffset = [scrollView contentOffset];
        CGSize size = [scrollView bounds].size;
        CGRect r = _tabBackgroundView.frame;
        if(r.origin.x - _leftSpaceWidth < contentOffset.x){
            [scrollView setContentOffset:CGPointMake(r.origin.x - _leftSpaceWidth, 0) animated:YES];
        }
        else if(r.origin.x + r.size.width + _rightSpaceWidth > contentOffset.x + size.width){
            [scrollView setContentOffset:CGPointMake(r.origin.x + r.size.width + _rightSpaceWidth - size.width, 0) animated:animated];
        }
    }
}

-(void) scrollToTabButton:(NSUInteger) index{
    UIButton * tabButton = [self tabButtonAtIndex:index];
    CGRect r = [_tabBackgroundView frame];
    CGRect rr = [tabButton frame];
    r.origin.x = rr.origin.x + (rr.size.width - r.size.width) / 2.0;
    [_tabBackgroundView setFrame:r];
    [self scrollToTabBackgroundVisable:YES];
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL) animated withoutOffset:(BOOL)withoutOffset{
    if(_selectedIndex != selectedIndex){
        
        NSUInteger index = 0;
        
        for (UIButton * button in self.tabButtons) {
            [button setEnabled:index != selectedIndex];
            index ++;
        }
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
        }
        
        [self scrollToTabButton:selectedIndex];
        
        if(animated){
            [UIView commitAnimations];
        }
        
        _selectedIndex = selectedIndex;
        
        if(!withoutOffset){
            [_pageContentView setContentOffset:CGPointMake(_selectedIndex * _pageContentView.bounds.size.width,0) animated:animated];
        }
        
        if([self.delegate respondsToSelector:@selector(vtTabDataController:didSelectedChanged:)]){
            [self.delegate vtTabDataController:self didSelectedChanged:_selectedIndex];
        }
    }
    else{
        [self scrollToTabBackgroundVisable:animated];
    }
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated{
    [self setSelectedIndex:selectedIndex animated:animated withoutOffset:NO];
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:NO];
}

-(UIButton *) tabButtonAtIndex:(NSUInteger) index{
    if(index < [self.tabButtons count]){
        return [self.tabButtons objectAtIndex:index];
    }
    return [self.tabButtons lastObject];
}

-(UIView *) contentViewAtIndex:(NSUInteger) index{
    if(index < [self.contentViews count]){
        return [self.contentViews objectAtIndex:index];
    }
    return [self.contentViews lastObject];
}

-(VTDataController *) controllerAtIndex:(NSUInteger) index{
    if(index < [self.controllers count]){
        return [self.controllers objectAtIndex:index];
    }
    return [self.controllers lastObject];
}

-(void) reloadDataController:(VTDataController *) dataController{
    VTDataSource * dataSource = dataController.dataSource;
    if(!dataSource.loading && !dataSource.loaded){
        [NSObject cancelPreviousPerformRequestsWithTarget:dataController selector:@selector(reloadData) object:nil];
        [dataController performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
    }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self setSelectedIndex:scrollView.contentOffset.x / scrollView.bounds.size.width animated:NO withoutOffset:YES];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self setSelectedIndex:scrollView.contentOffset.x / scrollView.bounds.size.width animated:NO withoutOffset:YES];
    }
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setSelectedIndex:scrollView.contentOffset.x / scrollView.bounds.size.width animated:NO withoutOffset:YES];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void) scrollView:(UIScrollView *) scrollView didContentOffsetChanged:(CGPoint) contentOffset{
    
    if(scrollView == _pageContentView){
        CGFloat index = contentOffset.x / scrollView.bounds.size.width;
        NSInteger count = scrollView.contentSize.width / scrollView.bounds.size.width;
        
        if(index <0){
            [self reloadDataController:[self controllerAtIndex:0]];
            [self scrollToTabButton:0];

        }
        else if(index >= count){
            [self reloadDataController:[self controllerAtIndex:count -1]];
            [self scrollToTabButton:count - 1];
        }
        else{
            CGFloat r = (index - (int) index);
            if(r == 0.0f || index > count -1){
                [self reloadDataController:[self controllerAtIndex:(int) index]];
                [self scrollToTabButton:(int) index];
                
            }
            else{
                
                [self reloadDataController:[self controllerAtIndex:(int) index]];
                [self reloadDataController:[self controllerAtIndex:(int) index + 1]];
                CGPoint p1 = [[self tabButtonAtIndex:(int) index] center];
                CGPoint p2 = [[self tabButtonAtIndex:(int) index + 1] center];
                
                CGRect rect = [_tabBackgroundView frame];
                
                rect.origin.x = p1.x + (p2.x - p1.x) * r - rect.size.width / 2.0;

                [_tabBackgroundView setFrame:rect];
                
                [self scrollToTabBackgroundVisable:NO];
            }
        }
    }
}

@end
