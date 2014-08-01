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

-(void) setView:(UIView *)view{
    [super setView:view];
    
    if(view){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self stringValueForKey:@"url"] relativeToURL:[self.document documentURL]]]];
    }
    else {
        [self.webView loadHTMLString:@"" baseURL:[self.document documentURL]];
    }
}

@end
