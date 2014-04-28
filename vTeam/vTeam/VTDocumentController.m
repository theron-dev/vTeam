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

@interface VTDocumentControllerDynamicData : NSObject

@property(nonatomic,retain) VTDOMElement * element;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,retain) NSString * key;
@property(nonatomic,retain) NSString * value;

@end

@implementation VTDocumentControllerDynamicData

-(void) dealloc{
    [_element release];
    [_text release];
    [_key release];
    [_value release];
    [super dealloc];
}

@end


@interface VTDocumentController()


@property(nonatomic,readonly) NSMutableArray * dynamicDatas;
@property(nonatomic,retain) VTDOMStatusElement * statusElement;

@end

@implementation VTDocumentController

@synthesize documentView = _documentView;
@synthesize html = _html;
@synthesize bundle = _bundle;
@synthesize dataItem = _dataItem;
@synthesize document = _document;
@synthesize allowAutoHeight = _allowAutoHeight;
@synthesize allowAutoWidth = _allowAutoWidth;
@synthesize dynamicDatas = _dynamicDatas;

-(void) dealloc{
    
    if([_documentView respondsToSelector:@selector(setDelegate:)]){
        [(id)_documentView setDelegate:nil];
    }
    
    [_statusElement release];

    [_html release];
    
    [_bundle release];
    
    [_dataItem release];
    
    [_dynamicDatas release];
    
    [_document release];
    
    [_documentView release];
    
    [super dealloc];
}

-(void) documentWillLoad{
    
    if([self hasDocumentDynamicDataBind]){
        
        NSMutableArray * dynamicDatas = [self dynamicDatas];
        
        [self addElement:self.document.rootElement toDynamicDatas:dynamicDatas];
        
        [self documentDynamicDataBind];
    }
    
}

-(void) documentDidLoad{
    
}

-(NSMutableArray *) dynamicDatas{
    if(_dynamicDatas == nil){
        _dynamicDatas = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return _dynamicDatas;
}

-(void) addElement:(VTDOMElement *)element toDynamicDatas:(NSMutableArray *) dynamicDatas{
    if(element){
        
        NSString * text = [element text];
        
        if(text && [text rangeOfString:@"{"].location != NSNotFound){
            
            VTDocumentControllerDynamicData * dynamic = [[VTDocumentControllerDynamicData alloc] init];
            
            [dynamic setText:[NSString stringWithString:text]];
            [dynamic setElement:element];
            
            [dynamicDatas addObject:dynamic];
            
            [dynamic release];
        }
        
        for(NSString * key in [[element attributes] allKeys]){
            
            NSString * v = [element attributeValueForKey:key];
            
            if(v && [v rangeOfString:@"{"].location != NSNotFound){
                
                VTDocumentControllerDynamicData * dynamic = [[VTDocumentControllerDynamicData alloc] init];
                
                [dynamic setKey:key];
                [dynamic setValue:[NSString stringWithString:v]];
                [dynamic setElement:element];
                
                [dynamicDatas addObject:dynamic];
                
                [dynamic release];
                
            }
            
        }
        
        for(VTDOMElement * child in [element childs]){
            [self addElement:child toDynamicDatas:dynamicDatas];
        }
        
    }
}

-(void) documentWillLayout{
    

    
}

-(void) documentDidLayout{
    
}

-(NSString *) htmlContent{
   
    NSBundle * bundle = self.bundle;
    
    if(bundle == nil){
        bundle = [self.context resourceBundle];
    }
    
    NSString * htmlContent = [NSString stringWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:self.html] encoding:NSUTF8StringEncoding error:nil];
    
    if(![self hasDocumentDynamicDataBind]){
        htmlContent = [htmlContent htmlStringByDOMSource:self];
    }
    
    return htmlContent;
    
}

-(BOOL) hasDocumentDynamicDataBind{
    return NO;
}

-(void) documentDynamicDataBind{
    
    for(VTDocumentControllerDynamicData * dynamic in _dynamicDatas){
        
        VTDOMElement * element = [dynamic element];
        
        NSString * text = [dynamic text];
        NSString * key = [dynamic key];
        
        if(text){
            [element setText:[text htmlStringByDOMSource:self htmlEncoded:NO]];
        }
        else if(key){
            [element setAttributeValue:[[dynamic value] htmlStringByDOMSource:self htmlEncoded:NO] forKey:key];
        }
    }
    
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
        
        NSBundle * bundle = self.bundle;
        
        if(bundle == nil){
            bundle = [self.context resourceBundle];
        }
        
        _document = [[VTDOMDocument alloc] init];
        _document.bundle = bundle;
        
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
    
    if([element isKindOfClass:[VTDOMStatusElement class]]){
        
        NSString * status = [(VTDOMStatusElement *) element status];
        
        if([status isEqualToString:@"topover"] || [status isEqualToString:@"leftover"]){
            if(_statusElement == nil && ![self isLoading]){
                
                self.statusElement = (VTDOMStatusElement *) element;
                
                [_statusElement setStatus:@"loading"];
                
                [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:NO];
                
            }
        }

    }
    
    [self onActionElement:element];
    
    if([self.delegate respondsToSelector:@selector(vtDocumentController:doActionElement:)]){
        [self.delegate vtDocumentController:self doActionElement:element];
    }
}

-(CGSize) contentSize{
    VTDOMElement * element =  [self.document rootElement];
    CGSize size = [element contentSize];
    CGRect r = [element frame];
    if(size.width < r.size.width){
        size.width = r.size.width;
    }
    if(size.height < r.size.height){
        size.height = r.size.height;
    }
    return size;
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
    
    [self cancelDownloadImagesForView:_documentView];
    
    [_documentView setElement:_document.rootElement];
    
    [self downloadImagesForView:_documentView];

}

-(BOOL) isDocumentLoaded{
    return _document != nil;
}

-(void) vtDOMView:(VTDOMView *)view downloadImagesForElement:(VTDOMElement *)element{
    [self downloadImagesForElement:element];
}

-(void) vtDOMView:(VTDOMView *)view downloadImagesForView:(UIView *) forView{
    [self downloadImagesForView:forView];
}

-(void) startLoading{
    
    if(_statusElement){
        
        VTDOMContainerElement * containerElement = (VTDOMContainerElement *) [_statusElement parentElement];
        
        while (containerElement && ![containerElement isKindOfClass:[VTDOMContainerElement class]]) {
            containerElement = (VTDOMContainerElement *) [containerElement parentElement];
        }
        
        if(containerElement){
            
            CGRect r = [_statusElement frame];
            
            UIScrollView * contentView = [containerElement contentView];
            
            [contentView setContentOffset:r.origin animated:YES];
            
        }
        
        [_statusElement setStatus:@"loading"];
        
        self.loading = YES;
    }
}

-(void) stopLoading{
    
    if(_statusElement){
        
        VTDOMContainerElement * containerElement = (VTDOMContainerElement *) [_statusElement parentElement];
        
        while (containerElement && ![containerElement isKindOfClass:[VTDOMContainerElement class]]) {
            containerElement = (VTDOMContainerElement *) [containerElement parentElement];
        }
        
        if(containerElement){
            
            UIScrollView * contentView = [containerElement contentView];
            
            if(contentView.contentOffset.y < 0 || contentView.contentOffset.x < 0){
                [contentView setContentOffset:CGPointZero animated:YES];
            }
            
        }
        
        [_statusElement setStatus:nil];
        
        self.statusElement = nil;
        
        self.loading = NO;
    }
}

@end
