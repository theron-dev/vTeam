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

        [element setAttributeValue:@"100%" forKey:@"width"];
        [element setAttributeValue:@"100%" forKey:@"height"];
        
        [element layout:size];
    
        CGRect r = [element frame];
        
        r.origin = CGPointMake(contentSize.width, 0);
        
        [element setFrame:r];
        
        contentSize.width += size.width;
    }
    
    [self setContentSize:contentSize];
    
    if([self isViewLoaded]){
        [self.contentView setContentSize:contentSize];
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
        
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"pageCount"];
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
        
        if([pageElement isKindOfClass:[VTDOMViewElement class]]){
            [[(VTDOMViewElement *) pageElement view] setElement:pageElement];
        }
    }
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
        
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",pageCount] forKey:@"pageCount"];
        [pageElement setAttributeValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
        
        if([pageElement isKindOfClass:[VTDOMViewElement class]]){
            [[(VTDOMViewElement *) pageElement view] setElement:pageElement];
        }
    }
    
}


@end
