//
//  VTDocumentViewController.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDocumentViewController.h"

@interface VTDocumentViewController ()

-(void) refreshView;

@end

@implementation VTDocumentViewController

@synthesize documentView = _documentView;
@synthesize html = _html;
@synthesize document = _document;

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
    
    [self reloadData];
}

-(void) viewDidUnload{
    [_documentView setDelegate:nil];
    [super viewDidUnload];
}

-(void) dealloc{
    [_html release];
    [_document release];
    [_documentView setDelegate:nil];
    [_documentView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element{
    
}

-(NSString *) htmlContent{
    
    NSBundle * bundle = self.nibBundle;
    
    if(bundle == nil){
        bundle = [NSBundle mainBundle];
    }
    
    NSString * htmlContent = [NSString stringWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:self.html] encoding:NSUTF8StringEncoding error:nil];
    
    htmlContent = [htmlContent htmlStringByDOMSource:self];

    return htmlContent;
}

-(void) reloadData{
    
    VTDOMParse * parse = [[VTDOMParse alloc] init];
    
    VTDOMDocument * document = [[VTDOMDocument alloc] init];
    
    [parse parseHTML:[self htmlContent] toDocument:document];
    
    [document setStyleSheet:[self.context domStyleSheet]];
    
    [self setDocument:document];
    
    [document release];
    
    [parse release];
    
    [self refreshView];
    
}

-(void) refreshView{
    
    if(_documentView && _document){
        CGSize contentSize = [[_document rootElement] layout:_documentView.frame.size];
        
        [_documentView setElement:[_document rootElement]];
        
        CGRect r = [_documentView frame];
        
        r.size.height = contentSize.height;
        
        [_documentView setFrame:r];
        
        UIScrollView * contentView = (UIScrollView *) [_documentView superview];
        
        if([contentView isKindOfClass:[UIScrollView class]]){
            [contentView setContentSize:CGSizeMake(0, r.origin.y + r.size.height)];
        }
    }
}

@end
