//
//  VTURLDocumentController.m
//  vTeam
//
//  Created by zhang hailong on 14-1-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTURLDocumentController.h"

#import "IVTUIContext.h"

#import "NSString+VTMD5String.h"

#import "VTDOMParse.h"

#import "VTDOMImageElement.h"

#import "UIView+Search.h"

#import "VTDOMElement+Layout.h"

#import "VTDOMStatusElement.h"

#import "VTDOMContainerElement.h"

#import "NSURL+QueryValue.h"

@interface  VTURLDocumentControllerElementHttpTask : VTHttpTask

@property(nonatomic,retain) VTDOMElement * element;

@end

@implementation VTURLDocumentControllerElementHttpTask

@synthesize element = _element;

-(void) dealloc{
    [_element release];
    [super dealloc];
}

@end

@interface VTURLDocumentController()

@property(nonatomic,retain) VTHttpTask * httpTask;
@property(nonatomic,retain) VTDOMStatusElement * statusElement;


-(void) startLoading;

-(void) stopLoading;

@end

@implementation VTURLDocumentController

@synthesize documentView = _documentView;
@synthesize document = _document;
@synthesize documentURL = _documentURL;
@synthesize httpTask = _httpTask;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize statusElement = _statusElement;
@synthesize documentUUID = _documentUUID;

-(void) dealloc{
    
    [self.context cancelHandleForSource:self];
    
    [_httpTask setDelegate:nil];
    [_httpTask release];
    [_documentView setDelegate:nil];
    [_documentView release];
    [_document release];
    [_documentURL release];
    [_statusElement release];
    [_documentUUID release];
    [super dealloc];
}

-(void) reloadData{
    
    if(_httpTask){
        [self.context cancelHandle:@protocol(IVTHttpResourceTask) task:_httpTask];
        self.httpTask = nil;
    }
    
    if([self.delegate respondsToSelector:@selector(vtURLDocumentControllerWillLoading:)]){
        [self.delegate vtURLDocumentControllerWillLoading:self];
    }
    
    if(_documentURL == nil){
        if([self.delegate respondsToSelector:@selector(vtURLDocumentController:didFailWithError:)]){
            [self.delegate vtURLDocumentController:self didFailWithError:[NSError errorWithDomain:NSStringFromClass([self class]) code:VTURLDocumentControllerErrorCodeNotFoundDocumentURL userInfo:[NSDictionary dictionaryWithObject:@"not found document URL" forKey:NSLocalizedDescriptionKey]]];
        }
        return;
    }
    
    NSString * scheme = [_documentURL scheme];
    
    if(![scheme hasPrefix:@"http"] && ![_documentURL isFileURL]){
        if([self.delegate respondsToSelector:@selector(vtURLDocumentController:didFailWithError:)]){
            [self.delegate vtURLDocumentController:self didFailWithError:[NSError errorWithDomain:NSStringFromClass([self class]) code:VTURLDocumentControllerErrorCodeNotSuppertDocumentURL userInfo:[NSDictionary dictionaryWithObject:@"not suppert document URL" forKey:NSLocalizedDescriptionKey]]];
        }
        return;
    }
    
    if([_documentURL isFileURL]){
        
        NSString * htmlContent = [NSString stringWithContentsOfURL:_documentURL encoding:NSUTF8StringEncoding error:nil];
        
        if(htmlContent){
            [self didLoadedHTMLContent:htmlContent];
        }
        else{
            [self didFailError:[NSError errorWithDomain:NSStringFromClass([self class]) code:VTURLDocumentControllerErrorCodeNotFoundFileURL userInfo:[NSDictionary dictionaryWithObject:@"not found file" forKey:NSLocalizedDescriptionKey]]];
        }
        
    }
    else{
        
        if(_allowPreloadCached){
            
            NSString * filePath = [self documentFilePath];
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            
            if([fileManager fileExistsAtPath:filePath]){
                
                [self loadHTMLContent:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
      
            }
            
        }
        
        VTHttpTask * httpTask = [[VTHttpTask alloc] init];
        
        [httpTask setSource:self];
        [httpTask setDelegate:self];
        [httpTask setResponseType:VTHttpTaskResponseTypeResource];
        [httpTask setAllowStatusCode302:YES];
        [httpTask setForceUpdateResource:YES];
        
        NSTimeInterval timeout = _timeoutInterval;
        
        if(timeout <= 0){
            timeout = 300;
        }
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:_documentURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
        
        [httpTask setRequest:request];
        
        NSLog(@"%@",_documentURL);
        
        
        self.httpTask = httpTask;
        
        [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
        
        [httpTask release];
        
        if([self.delegate respondsToSelector:@selector(vtURLDocumentControllerWillLoading:)]){
            [self.delegate vtURLDocumentControllerWillLoading:self];
        }
    }
}

-(BOOL) isLoading{
    return _httpTask != nil;
}

-(NSString *) documentFilePath{

    NSString * filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/htmls/%@%@",[_documentURL host],[_documentURL path]];
    
    if([filePath hasSuffix:@"/"]){
        filePath = [filePath stringByAppendingPathComponent:@"index.html"];
    }
    
    if([_documentURL.query length]){
        
        filePath = [filePath stringByAppendingPathExtension:[_documentURL.query vtMD5String]];
        
    }
    
    return filePath;
}

-(void) loadHTMLContent:(NSString *) htmlContent{
    
    NSString * uuid = [htmlContent vtMD5String];
    
    if([_documentUUID isEqualToString:uuid]){
        return;
    }
    
    self.documentUUID = uuid;
    
    VTDOMParse * parse = [[VTDOMParse alloc] init];
    
    [_documentView setElement:nil];
    
    self.document = nil;
    
    _document = [[VTDOMDocument alloc] init];
    
    [_document setDocumentURL:_documentURL];
    
    [parse parseHTML:htmlContent toDocument:_document];
    
    [_document setStyleSheet:[self.context domStyleSheet]];
    
    [_documentView setAllowAutoLayout:YES];
    [_documentView setElement:_document.rootElement];
    
    [self downloadImagesForElement:_document.rootElement];
    [self downloadImagesForView:_documentView];
    
    
}

-(void) didLoadedHTMLContent:(NSString *) htmlContent{
    
    [self stopLoading];
    
    [self loadHTMLContent:htmlContent];
 
    if([self.delegate respondsToSelector:@selector(vtURLDocumentControllerDidLoaded:)]){
        [self.delegate vtURLDocumentControllerDidLoaded:self];
    }
}

-(void) didFailError:(NSError *) error{
    
    NSString * filePath = [self documentFilePath];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath]){
        
        [self didLoadedHTMLContent:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
        
    }
    else{
        
        [self stopLoading];
        
        if([self.delegate respondsToSelector:@selector(vtURLDocumentController:didFailWithError:)]){
            [self.delegate vtURLDocumentController:self didFailWithError:error];
        }
    }
}

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error{
    
    if(_httpTask == httpTask){
        
        [self didFailError:error];
        
        [_httpTask setDelegate:nil];
        self.httpTask = nil;
    }
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    if(_httpTask == httpTask){
        
        NSString * filePath = [self documentFilePath];
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        NSString * dir = [filePath stringByDeletingLastPathComponent];
        
        if(![fileManager fileExistsAtPath:dir]){
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        [fileManager removeItemAtPath:filePath error:nil];
        
        [fileManager moveItemAtPath:[httpTask responseBody] toPath:filePath error:nil];
        
        [self didLoadedHTMLContent:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil]];
        
        [_httpTask setDelegate:nil];
        self.httpTask = nil;
        
    }
    else if([httpTask isKindOfClass:[VTURLDocumentControllerElementHttpTask class]]){
        
        VTDOMElement * element = [httpTask element];
        NSString * method = [element attributeValueForKey:@"method"];
        
        if([method isEqualToString:@"replace"]){
            
            VTDOMElement * parentElement = [element parentElement];
            
            NSArray * childs = [parentElement childs];
            
            NSInteger index = [childs indexOfObject:element];
            
            if(index != NSNotFound){
                
                NSString * name = [element attributeValueForKey:@"group"];
                
                while(index < [childs count]){
                    VTDOMElement * el = [childs objectAtIndex:index];
                    if([name isEqualToString:[el attributeValueForKey:@"name"]]){
                        [el removeFromParentElement];
                    }
                    else{
                        index ++;
                    }
                }
                
                VTDOMParse * parse = [[VTDOMParse alloc] init];
                
                [parse parseHTML:[httpTask responseBody] toElement:parentElement atIndex:index + 1];
                
                [self.document applyStyleSheet:parentElement];
                
                [[self.document rootElement] layout:_documentView.bounds.size];
                
                [[self.document rootElement] bindDelegate:_documentView];
                
                [_documentView setNeedsDisplay];
            }
            
        }
        else {
            
            for(VTDOMElement * el in [NSArray arrayWithArray:[element childs]]){
                [el removeFromParentElement];
            }
            
            VTDOMParse * parse = [[VTDOMParse alloc] init];
            
            [parse parseHTML:[httpTask responseBody] toElement:element];
            
            [self.document applyStyleSheet:element];
            
            [[self.document rootElement] layout:_documentView.bounds.size];
            
            [[self.document rootElement] bindDelegate:_documentView];
            
            [_documentView setNeedsDisplay];
            
        }
        
        
    }
}

-(void) vtHttpTaskDidResponse:(id)httpTask{
    
    if(_httpTask == httpTask){
        
        NSHTTPURLResponse * response = (NSHTTPURLResponse *) [httpTask response];
        
        if([response statusCode] != 200){
            
            
            [self didFailError:[NSError errorWithDomain:NSStringFromClass([self class]) code:[response statusCode] userInfo:[NSDictionary dictionaryWithObject:[NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]] forKey:NSLocalizedDescriptionKey]]];
            
            
            
            [_httpTask setDelegate:nil];
            self.httpTask = nil;
        }
        
    }
    
}

-(void) downloadImagesForElement:(VTDOMElement *) element{
    
    if([element isKindOfClass:[VTDOMImageElement class]]){
        
        VTDOMImageElement * imgElement = (VTDOMImageElement *) element;
        
        if((imgElement.delegate || [imgElement isPreload])
           && ![imgElement isLoading] && ![imgElement isLoaded]){
            [imgElement setSource:self];
            [self.context handle:@protocol(IVTImageTask) task:imgElement priority:0];
        }
        
    }
    
    for(VTDOMElement * el in [element childs]){
        [self downloadImagesForElement:el];
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

-(void) vtDOMView:(VTDOMView *)view downloadImagesForElement:(VTDOMElement *)element{
    [self downloadImagesForElement:element];
}

-(void) vtDOMView:(VTDOMView *)view downloadImagesForView:(UIView *) forView{
    [self downloadImagesForView:forView];
}

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element{
    
    if([element isKindOfClass:[VTDOMStatusElement class]]){
        
        NSString * status = [(VTDOMStatusElement *) element status];
        
        if([status isEqualToString:@"topover"] || [status isEqualToString:@"leftover"]){
            if(_statusElement == nil && ![self isLoading]){
                
                self.statusElement = (VTDOMStatusElement *) element;
                
                [_statusElement setStatus:@"loading"];
                
                [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:NO];
                
                [self reloadData];
            }
        }
        else if([status isEqualToString:@"right"] || [status isEqualToString:@"bottom"] || [status isEqualToString:@"bottomover"] || [status isEqualToString:@"rightover"]){
            [self reloadElement:element queryValues:nil];
            [(VTDOMStatusElement *) element setStatus:@"loading"];
        }
        
    }
    else {
        
        NSString * actionName = [element attributeValueForKey:@"action-name"];
        
        if([actionName isEqualToString:@"reload-url"]){
            
            [self reloadElement:element queryValues:nil];
            
        }
    }
    
    if([self.delegate respondsToSelector:@selector(vtURLDocumentController:doActionElement:)]){
        [self.delegate vtURLDocumentController:self doActionElement:element];
    }
}

-(void) reloadElement:(VTDOMElement *) element queryValues:(NSDictionary *) queryValues{
    
    NSString * url = [element attributeValueForKey:@"url"];
    
    if(url){
        
        VTURLDocumentControllerElementHttpTask * httpTask = [[VTURLDocumentControllerElementHttpTask alloc] initWithSource:self];
        
        [httpTask setDelegate:self];
        [httpTask setElement:element];
        [httpTask setResponseType:VTHttpTaskResponseTypeString];
        [httpTask setAllowStatusCode302:YES];
        
        NSTimeInterval timeout = _timeoutInterval;
        
        if(timeout <= 0){
            timeout = 300;
        }
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:_documentURL queryValues:queryValues] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
        
        [httpTask setRequest:request];
        
        [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
        
        [httpTask release];
        
        NSLog(@"%@",request);
        
    }
    
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
    }
}

-(IBAction) doRefreshAction:(id)sender{
    if(![self isLoading]){
        [self reloadData];
    }
}

-(void) relayout{
    
    [self.document.rootElement layout:_documentView.bounds.size];
    
    [_documentView setNeedsDisplay];
}

@end
