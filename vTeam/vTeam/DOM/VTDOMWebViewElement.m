//
//  VTDOMWebViewElement.m
//  vTeam
//
//  Created by zhang hailong on 14-8-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMWebViewElement.h"

#import "VTDOMElement+Control.h"
#import "VTDOMElement+Style.h"
#import "VTDOMElement+Layout.h"
#import "VTWebView.h"
#import "VTDOMDocument.h"

@implementation VTDOMWebViewElement

-(UIWebView *) webView{
    return (UIWebView *) [self view];
}

-(Class) viewClass{
    NSString * view = [self stringValueForKey:@"viewClass"];
    Class clazz = NSClassFromString(view);
    if(clazz == nil || ![clazz isSubclassOfClass:[UIWebView class]]){
        clazz = [VTWebView class];
    }
    return clazz;
}

-(void) dealloc{
    
    [super dealloc];
}

-(void) setView:(UIView *)view{
    
    [self.webView setDelegate:nil];

    
    [super setView:view];
    
    [self.webView setDelegate:self];

}


-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    
    if([self isViewLoaded] && delegate){
        
        NSString * src = [self stringValueForKey:@"src"];
        
        if([src length]){
            
            NSURL * url = [NSURL URLWithString:src relativeToURL:[self.document documentURL]];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            
        }
        else {
            
            [self.webView loadHTMLString:[self text] baseURL:[self.document documentURL]];
        }
        
    }
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(size.width, size.height);
    
    [self setContentSize:contentSize];
    
    return size;
}

@end
