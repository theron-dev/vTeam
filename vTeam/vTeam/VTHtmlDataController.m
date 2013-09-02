//
//  VTHtmlDataController.m
//  vTeam
//
//  Created by sinanews on 13-9-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHtmlDataController.h"

@implementation VTHtmlDataController
@synthesize webView = _webView;

-(void)dealloc
{
    [_webView setDelegate:nil];
    [_webView stopLoading];
    [_webView release];
    [super dealloc];
}

@end
