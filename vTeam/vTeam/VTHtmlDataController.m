//
//  VTHtmlDataController.m
//  vTeam
//
//  Created by shenyue on 13-9-2.
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

- (void)setShowShadows:(BOOL)bShow;
{
	// Reference: http://stackoverflow.com/questions/1074320/remove-uiwebview-shadow
    
	// 遍历UIScrollView隐藏阴影.
	for (UIView *inScrollView in [_webView subviews])
	{
		if ([inScrollView isKindOfClass:[UIImageView class]])
		{
			inScrollView.hidden = !bShow;
		}
	}
    
    for (UIView *inScrollView in [[_webView subviews][0] subviews])
	{
		if ([inScrollView isKindOfClass:[UIImageView class]])
		{
			inScrollView.hidden = !bShow;
		}
	}
}

@end
