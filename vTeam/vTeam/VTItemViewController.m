//
//  VTItemViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-5-2.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTItemViewController.h"

@interface VTItemViewController ()

@end

@implementation VTItemViewController

@synthesize context = _context;
@synthesize styleContainer = _styleContainer;
@synthesize dataOutletContainer = _dataOutletContainer;

@synthesize index = _index;
@synthesize userInfo = _userInfo;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize delegate = _delegate;
@synthesize dataItem = _dataItem;
@synthesize layoutContainer = _layoutContainer;

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
    [_styleContainer setStyleSheet:[self.context styleSheet]];
    [_layoutContainer layout];
}

-(void) viewDidUnload{
    [self setStyleContainer:nil];
    [self setDataOutletContainer:nil];
    [super viewDidUnload];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [_dataItem release];
    [_userInfo release];
    [_reuseIdentifier release];
    [_styleContainer release];
    [_dataOutletContainer release];
    [super dealloc];
}


-(IBAction) doAction :(id)sender{
    if([sender conformsToProtocol:@protocol(IVTAction)]){
        if([_delegate respondsToSelector:@selector(vtItemViewController:doAction:)]){
            [_delegate vtItemViewController:self doAction:sender];
        }
    }
}

-(void) setDataItem:(id)dataItem{
    if(_dataItem != dataItem){
        [_dataItem release];
        _dataItem = [dataItem retain];
        if(_dataItem){
            [self view];
            [_dataOutletContainer applyDataOutlet:_dataItem];
            [_layoutContainer layout];
        }
    }
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_layoutContainer layout];
}

@end
