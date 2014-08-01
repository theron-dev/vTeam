//
//  VTDOMWebViewElement.h
//  vTeam
//
//  Created by zhang hailong on 14-8-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMViewElement.h>

@interface VTDOMWebViewElement : VTDOMViewElement<UIWebViewDelegate>

@property(nonatomic,readonly) UIWebView * webView;

@end
