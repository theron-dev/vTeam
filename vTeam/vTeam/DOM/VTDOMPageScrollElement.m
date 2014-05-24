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
#import "VTDOMDocument.h"
#import "UIView+VTDOMElement.h"

@interface VTDOMPageScrollElement()

@end

@implementation VTDOMPageScrollElement

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(0, size.height);
    
    for (VTDOMElement * element in [self childs]) {

        UIEdgeInsets margin = [element margin];
        
        [element setAttributeValue:@"100%" forKey:@"width"];
        [element setAttributeValue:@"100%" forKey:@"height"];
        
        [element layout:CGSizeMake(size.width - margin.left - margin.right
                                   , size.height - margin.top - margin.bottom)];
    
        CGRect r = [element frame];
        
        r.origin = CGPointMake(contentSize.width + margin.left, margin.top);
        
        [element setFrame:r];
        
        contentSize.width += size.width;
    }
    
    [self setContentSize:contentSize];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
        [self reloadData];
    }
    
    return size;
}

-(void) setView:(UIView *)view{
    
    [super setView:view];
    
    [self.contentView setPagingEnabled:YES];

}

-(VTDOMElement *) pageElement{
    
    NSString * pageId = [self stringValueForKey:@"page-id"];
    
    if(pageId){
        return [self.document elementById:pageId];
    }
    
    return nil;
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    [self reloadData];
    
    VTDOMElement * pageElement = [self pageElement];
    
    if(pageElement){
        
        UIScrollView * contentView = [self contentView];
        
        CGSize size = contentView.bounds.size;
        CGSize contentSize = contentView.contentSize;
        CGPoint contentOffset = contentView.contentOffset;
        
        if(contentSize.width < size.width){
            contentSize.width = size.width;
        }
        
        NSInteger pageCount = contentSize.width / size.width;
        
        NSInteger pageIndex = contentOffset.x / size.width;
        
        if(pageIndex >= pageCount){
            pageIndex = pageCount - 1;
        }
        
        if(pageIndex < 0){
            pageIndex = 0;
        }
        
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",(int)pageCount] forKey:@"pageCount"];
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"pageIndex"];
        
        if([pageElement isKindOfClass:[VTDOMViewElement class]]){
            [[(VTDOMViewElement *) pageElement view] setElement:pageElement];
        }
    }
}

-(NSInteger) pageIndex{
    
    if([self isViewLoaded]){
        UIScrollView * contentView = [self contentView];
        
        CGSize size = contentView.bounds.size;
        CGSize contentSize = contentView.contentSize;
        CGPoint contentOffset = contentView.contentOffset;
        
        if(contentSize.width < size.width){
            contentSize.width = size.width;
        }
        
        NSInteger pageCount = contentSize.width / size.width;
        
        NSInteger pageIndex = contentOffset.x / size.width;
        
        if(pageIndex >= pageCount){
            pageIndex = pageCount - 1;
        }
        
        if(pageIndex < 0){
            pageIndex = 0;
        }

        return pageIndex;
    }
    return 0;
}

-(NSInteger) pageSize{
    
    if([self isViewLoaded]){
        
        UIScrollView * contentView = [self contentView];
        
        CGSize size = contentView.bounds.size;
        CGSize contentSize = contentView.contentSize;
        
        if(contentSize.width < size.width){
            contentSize.width = size.width;
        }
        
        return contentSize.width / size.width;
    }
    return 0;
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    VTDOMElement * pageElement = [self pageElement];
    
    if(pageElement){
        
        UIScrollView * contentView = [self contentView];
        
        CGSize size = contentView.bounds.size;
        CGSize contentSize = contentView.contentSize;
        CGPoint contentOffset = contentView.contentOffset;
        
        if(contentSize.width < size.width){
            contentSize.width = size.width;
        }
        
        NSInteger pageCount = contentSize.width / size.width;
        
        NSInteger pageIndex = contentOffset.x / size.width;
        
        if(pageIndex >= pageCount){
            pageIndex = pageCount - 1;
        }
        
        if(pageIndex < 0){
            pageIndex = 0;
        }
        
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",(int)pageCount] forKey:@"pageCount"];
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",(int)pageIndex] forKey:@"pageIndex"];
        
        if([pageElement isKindOfClass:[VTDOMViewElement class]]){
            [[(VTDOMViewElement *) pageElement view] setElement:pageElement];
        }
    }
    
}

-(void) doLoops {
    
    UIScrollView * contentView = [self contentView];
    
    CGSize size = contentView.bounds.size;
    CGSize contentSize = contentView.contentSize;
    CGPoint contentOffset = contentView.contentOffset;
    
    if(contentSize.width < size.width){
        contentSize.width = size.width;
    }
    
    NSInteger pageCount = contentSize.width / size.width;
    
    NSInteger pageIndex = contentOffset.x / size.width;
    
    if(pageIndex >= pageCount){
        pageIndex = pageCount - 1;
    }
    
    if(pageIndex + 1 >= pageCount){
        pageIndex = 0;
    }
    else {
        pageIndex ++;
    }
    
    if(pageIndex < 0){
        pageIndex = 0;
    }
    
    [contentView setContentOffset:CGPointMake(pageIndex * size.width, 0) animated:YES];
    
    NSString * v = [self attributeValueForKey:@"loops"];
    NSTimeInterval interval = [v doubleValue];
    
    if(interval > 0){
        
        [self performSelector:@selector(doLoops) withObject:nil afterDelay:interval];
        
    }
    
}

-(void) didContainerDidAppera{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doLoops) object:nil];
    
    NSString * v = [self attributeValueForKey:@"loops"];
    NSTimeInterval interval = [v doubleValue];
    
    if(interval > 0){
        
        [self performSelector:@selector(doLoops) withObject:nil afterDelay:interval];
        
    }
    
}

-(void) didContainerDidDispaaer{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doLoops) object:nil];
    
    
}


@end
