//
//  VTTabPageDataController.m
//  vTeam
//
//  Created by zhang hailong on 13-7-12.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTTabPageDataController.h"

@implementation VTTabPageDataController

@synthesize pageContentView = _pageContentView;
@synthesize tabBackgroundView = _tabBackgroundView;

-(void) dealloc{
    [_pageContentView setDelegate:nil];
    [_pageContentView release];
    [_tabBackgroundView release];
    [super dealloc];
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL) animated{
    if(_selectedIndex != selectedIndex){
        
        NSUInteger index = 0;
        
        for (UIButton * button in self.tabButtons) {
            [button setSelected:index == selectedIndex];
            index ++;
        }
        
        if(animated){
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
        }
        
        [_tabBackgroundView setCenter:[[self tabButtonAtIndex:selectedIndex] center]];
        
        if(animated){
            [UIView commitAnimations];
        }
        
        _selectedIndex = selectedIndex;
        
        if(animated){
            [_pageContentView setContentOffset:CGPointMake(_selectedIndex * _pageContentView.bounds.size.width,0) animated:YES];
        }
        
        if([self.delegate respondsToSelector:@selector(vtTabDataController:didSelectedChanged:)]){
            [self.delegate vtTabDataController:self didSelectedChanged:_selectedIndex];
        }
    }
}

-(void) setSelectedIndex:(NSUInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:YES];
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
        [dataController reloadData];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setSelectedIndex:scrollView.contentOffset.x / scrollView.bounds.size.width animated:NO];
}

-(void) scrollView:(UIScrollView *) scrollView didContentOffsetChanged:(CGPoint) contentOffset{
    
    if(scrollView == _pageContentView){
        CGFloat index = contentOffset.x / scrollView.bounds.size.width;
        NSInteger count = scrollView.contentSize.width / scrollView.bounds.size.width;
        
        if(index <0){
            [self reloadDataController:[self controllerAtIndex:0]];
            [_tabBackgroundView setCenter:[[self tabButtonAtIndex:0] center]];

        }
        else if(index >= count){
            [self reloadDataController:[self controllerAtIndex:count -1]];
            [_tabBackgroundView setCenter:[[self tabButtonAtIndex:count -1] center]];
        }
        else{
            CGFloat r = (index - (int) index);
            if(r == 0.0f || index > count -1){
                [self reloadDataController:[self controllerAtIndex:(int) index]];
                [_tabBackgroundView setCenter:[[self tabButtonAtIndex:(int) index] center]];
                
            }
            else{
                
                [self reloadDataController:[self controllerAtIndex:(int) index]];
                [self reloadDataController:[self controllerAtIndex:(int) index + 1]];
                CGPoint p1 = [[self tabButtonAtIndex:(int) index] center];
                CGPoint p2 = [[self tabButtonAtIndex:(int) index + 1] center];
                
                [_tabBackgroundView setCenter:CGPointMake(p1.x + (p2.x - p1.x) * r, p1.y + (p2.y - p1.y) * r)];
                
            }
        }
    }
}

@end
