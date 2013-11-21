//
//  VTDocumentController.m
//  vTeam
//
//  Created by zhang hailong on 13-11-20.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDocumentController.h"

#import "UIView+Search.h"

#import "NSString+VTDOMSource.h"

@implementation VTDocumentController

@synthesize documentView = _documentView;
@synthesize html = _html;
@synthesize bundle = _bundle;
@synthesize dataItem = _dataItem;
@synthesize document = _document;
@synthesize allowAutoHeight = _allowAutoHeight;
@synthesize allowAutoWidth = _allowAutoWidth;

-(void) dealloc{
    
    if([_documentView respondsToSelector:@selector(setDelegate:)]){
        [(id)_documentView setDelegate:nil];
    }
    
    [_documentView release];
    
    [_html release];
    
    [_bundle release];
    
    [_dataItem release];
    
    [_document release];
    
    [super dealloc];
}

-(void) documentWillLoad{
    
}

-(void) documentDidLoad{
    
}

-(void) documentWillLayout{
    
}

-(void) documentDidLayout{
    
}

-(NSString *) htmlContent{
   
    NSBundle * bundle = self.bundle;
    
    if(bundle == nil){
        bundle = [NSBundle mainBundle];
    }
    
    NSString * htmlContent = [NSString stringWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:self.html] encoding:NSUTF8StringEncoding error:nil];
    
    htmlContent = [htmlContent htmlStringByDOMSource:self];
    
    return htmlContent;
    
}


-(void) downloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if(![imageView isLoading] && ![imageView isLoaded]){
            [imageView setSource:self];
            [self.context handle:@protocol(IVTImageTask) task:imageView priority:0];
        }
    }
}

-(void) loadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView isLoading]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
        if(![imageView isLoaded]){
            [self.context handle:@protocol(IVTLocalImageTask) task:imageView priority:0];
        }
    }
}

-(void) cancelDownloadImagesForView:(UIView *) view{
    NSArray * imageViews = [view searchViewForProtocol:@protocol(IVTImageTask)];
    for(id imageView in imageViews){
        if([imageView isLoading]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imageView];
        }
    }
}

-(void) loadImagesForElement:(VTDOMElement *) element{
    
    if([element isKindOfClass:[VTDOMImageElement class]]){
        
        VTDOMImageElement * imgElement = (VTDOMImageElement *) element;
        
        if([imgElement isLoading]){
            [self.context cancelHandle:@protocol(IVTImageTask) task:imgElement];
        }
        
        [self.context handle:@protocol(IVTLocalImageTask) task:imgElement priority:0.0];
    }
    
    for(VTDOMElement * el in [element childs]){
        [self loadImagesForElement:el];
    }
}

-(void) downloadImagesForElement:(VTDOMElement *) element{
    
    if([element isKindOfClass:[VTDOMImageElement class]]){
        
        VTDOMImageElement * imgElement = (VTDOMImageElement *) element;
        
        if(![imgElement isLoading] && ![imgElement isLoaded]){
            [imgElement setSource:self];
            [self.context handle:@protocol(IVTImageTask) task:imgElement priority:0];
        }
        
    }
    
    for(VTDOMElement * el in [element childs]){
        [self downloadImagesForElement:el];
    }
    
}

-(VTDOMDocument *) document{
    
    if(_document == nil){
        
        _document = [[VTDOMDocument alloc] init];
        
        VTDOMParse * parse = [[VTDOMParse alloc] init];
        
        [parse parseHTML:[self htmlContent] toDocument:_document];
        
        [parse release];
        
        [self documentWillLoad];
        
        [_document setStyleSheet:[self.context domStyleSheet]];
        
        [self documentDidLoad];
        
        CGSize size = [_documentView bounds].size;
        
        if(_allowAutoWidth){
            size.width = MAXFLOAT;
        }
        
        if(_allowAutoHeight){
            size.height = MAXFLOAT;
        }
        
        [self documentWillLayout];
        
        [[_document rootElement] layout:size];
        
        [self documentDidLayout];
    
        [self downloadImagesForElement:_document.rootElement];
    }
    
    return _document;
}

-(void) reloadData{
    
    [self cancelDownloadImagesForView:self.documentView];
    
    [_documentView setElement:[self.document rootElement]];
    
    [self downloadImagesForView:_documentView];
}

-(void) onActionElement:(VTDOMElement *) element{
    
}

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element{
    
    [self onActionElement:element];
    
    if([self.delegate respondsToSelector:@selector(vtDocumentController:doActionElement:)]){
        [self.delegate vtDocumentController:self doActionElement:element];
    }
}

-(CGSize) contentSize{
    return [[self.document rootElement] contentSize];
}

-(void) documentLayout{
    
    CGSize size = [_documentView bounds].size;
    
    if(_allowAutoWidth){
        size.width = MAXFLOAT;
    }
    
    if(_allowAutoHeight){
        size.height = MAXFLOAT;
    }
    
    [self documentWillLayout];
    
    [[_document rootElement] layout:size];
    
    [self documentDidLayout];
    
    [self downloadImagesForElement:_document.rootElement];
    
    [_documentView setElement:nil];
    [_documentView setElement:_document.rootElement];
    
    [self downloadImagesForView:_documentView];
}

@end
