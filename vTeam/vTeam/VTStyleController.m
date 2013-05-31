//
//  VTStyleSheetController.m
//  vTeam
//
//  Created by zhang hailong on 13-5-31.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTStyleController.h"

@interface VTStyleController ()

@end

@implementation VTStyleController

@synthesize styles = _styles;

-(void) dealloc{
    [_styles release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
