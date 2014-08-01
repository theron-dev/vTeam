//
//  VTDOMWebContainerElement.m
//  vTeam
//
//  Created by zhang hailong on 14-8-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMWebContainerElement.h"

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"
#import "VTDOMDocument.h"
#import "VTWebView.h"

@interface VTDOMWebContainerElement()

@property(nonatomic,readonly) UIWebView * webView;
@property(nonatomic,assign,getter = isWebViewLoaded) BOOL webViewLoaded;

@end

@implementation VTDOMWebContainerElement


-(UIWebView *) webView{
    return (UIWebView *) self.view;
}

-(UIScrollView *) contentView{
    return [(UIWebView *) self.view scrollView];
}

-(Class) viewClass{
    NSString * view = [self stringValueForKey:@"viewClass"];
    Class clazz = NSClassFromString(view);
    if(clazz == nil || ![clazz isSubclassOfClass:[UIWebView class]]){
        clazz = [VTWebView class];
    }
    return clazz;
}

-(CGRect) frameInElement:(VTDOMElement *) element{
    CGRect r = [element frame];
    r.origin.y += [self.contentView contentSize].height;
    return r;
}

-(void) dealloc{
    [self.webView setDelegate:nil];
    [super dealloc];
}

-(void) setView:(UIView *)view{
    
    [self.webView setDelegate:nil];
    
    self.webViewLoaded = NO;
    
    [super setView:view];

    
    [self.webView setDelegate:self];
    
    if(view){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self stringValueForKey:@"src"] relativeToURL:[self.document documentURL]]]];
    }
    else {
        [self.webView loadHTMLString:@"" baseURL:[self.document documentURL]];
    }
    
    
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(size.width, 0);
    
    for (VTDOMElement * element in [self childs]) {
        
        UIEdgeInsets margin = [element margin];
        
        [element layout:CGSizeMake(size.width - margin.left - margin.right - padding.left - padding.right
                                   , size.height)];
        
        CGRect r = element.frame;
        
        r.origin = CGPointMake(padding.left + margin.left, contentSize.height + margin.top + padding.top);
        r.size.width = size.width - padding.left - padding.right - margin.left - margin.right;
        
        [element setFrame:r];
        
        contentSize.height += r.size.height + margin.top + margin.bottom;
    }
    
    contentSize.height += padding.top + padding.bottom;
    
    [self setContentSize:contentSize];
    
    if([self isViewLoaded] && self.webViewLoaded){
        [self reloadData];
    }
    
    return size;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        
        [self setAttributeValue:[[request URL] absoluteString] forKey:@"link"];
        
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:self];
        }

        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    CGSize contentSize = [self contentSize];
    
    [self.contentView setContentInset:UIEdgeInsetsMake(0, 0, contentSize.height, 0)];
    
    if(! self.webViewLoaded){
        [self.contentView setContentOffset:CGPointZero];
    }
    
    [self reloadData];
    
    self.webViewLoaded = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void) didViewLoaded{
    
}

@end
