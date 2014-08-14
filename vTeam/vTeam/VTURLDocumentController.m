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

#import "VTDOMElement+Style.h"

#import "VTDOMStatusElement.h"

#import "VTDOMContainerElement.h"

#import "NSURL+QueryValue.h"


@interface  VTURLDocumentControllerElementHttpTask : VTHttpTask

@property(nonatomic,retain) VTDOMElement * element;
@property(nonatomic,retain) VTDOMElement * topElement;

@end

@implementation VTURLDocumentControllerElementHttpTask

@synthesize element = _element;

-(void) dealloc{
    [_element release];
    [super dealloc];
}

@end

@interface VTURLDocumentController()

-(VTDOMElement *) topElement:(VTDOMElement *) element;

-(void) startLoading:(VTDOMElement *) element;

-(void) stopLoading:(VTDOMElement *) element;

@end

@implementation VTURLDocumentController

@synthesize documentView = _documentView;
@synthesize document = _document;
@synthesize documentURL = _documentURL;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize documentUUID = _documentUUID;

-(void) dealloc{
    
    [self.context cancelHandleForSource:self];
    
    [_documentView setDelegate:nil];
    [_documentView release];
    [_document release];
    [_documentURL release];
    [_documentUUID release];
    [_errorDocument release];
    [super dealloc];
}

-(VTDOMElement *) topElement:(VTDOMElement *)element{
    
    if(element == nil){
        return self.document.rootElement;
    }
    
    if([element booleanValueForKey:@"loadContent"]){
        
        return element;
    }
    
    if(element.parentElement){
    
        return [self topElement:element.parentElement];
    }
    
    return element;
}

-(void) cancel{
    [self.context cancelHandleForSource:self];
}

-(void) reloadData{
    
    [self.context cancelHandleForSource:self];
    
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
            [self didLoadedHTMLContent:htmlContent element:nil];
        }
        else{
            [self didFailError:[NSError errorWithDomain:NSStringFromClass([self class]) code:VTURLDocumentControllerErrorCodeNotFoundFileURL userInfo:[NSDictionary dictionaryWithObject:@"not found file" forKey:NSLocalizedDescriptionKey]] element:nil];
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
        
        VTURLDocumentControllerElementHttpTask * httpTask
            = [[VTURLDocumentControllerElementHttpTask alloc] init];
        
        [httpTask setTopElement:[self topElement:nil]];
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
        
        NSLog(@"%@",[_documentURL absoluteString]);
    
        [[httpTask topElement] setAttributeValue:@"true" forKey:@"loading"];
        
        [self.context handle:@protocol(IVTHttpResourceTask) task:httpTask priority:0];
        
        
    }
}

-(BOOL) isLoading{
    return [[self topElement:nil] booleanValueForKey:@"loading"];
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
    
    [self documentWillLoad];
    
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
    
    [self documentDidLoad];
    
    [_documentView setAllowAutoLayout:YES];
    [_documentView setElement:_document.rootElement];
    
    [self downloadImagesForElement:_document.rootElement];
    [self downloadImagesForView:_documentView];
    
    [self documentDidVisable];
}

-(void) delayDidLoadedHTMLContent:(NSString *) htmlContent {
    
    [self loadHTMLContent:htmlContent];
    
    if([self.delegate respondsToSelector:@selector(vtURLDocumentControllerDidLoaded:)]){
        [self.delegate vtURLDocumentControllerDidLoaded:self];
    }
}

-(void) didLoadedHTMLContent:(NSString *) htmlContent element:(VTDOMElement *) element{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self stopLoading:element];
    
    if(self.document){
        [self performSelector:@selector(delayDidLoadedHTMLContent:) withObject:htmlContent afterDelay:0.3];
    }
    else {
        [self delayDidLoadedHTMLContent:htmlContent];
    }
    
}

-(void) didFailError:(NSError *) error element:(VTDOMElement *) element{
    
    NSString * filePath = [self documentFilePath];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath]){
        
        [self didLoadedHTMLContent:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] element:element];
        
    }
    else{
        
        [self stopLoading:element];
        
        if(_errorDocument){
            NSString * html = [[[self.context resourceBundle] bundlePath] stringByAppendingPathComponent:_errorDocument];
            
            NSString * htmlContent = [NSString stringWithContentsOfFile:html encoding:NSUTF8StringEncoding error:nil];
            
            if(htmlContent){
                
                [self loadHTMLContent:htmlContent];
                
            }
            
        }
        
        if([self.delegate respondsToSelector:@selector(vtURLDocumentController:didFailWithError:)]){
            [self.delegate vtURLDocumentController:self didFailWithError:error];
        }
    }
}

-(void) vtHttpTask:(id) httpTask didFailError:(NSError *) error{
    
    VTDOMElement * topElement = [httpTask topElement];
    
    if(topElement == [self topElement:nil]){
        
        [[httpTask element] setAttributeValue:@"" forKey:@"status"];
        
        [self didFailError:error element:[httpTask element]];
        
    }
    else if(topElement.document == self.document){
        
        [[httpTask element] setAttributeValue:@"" forKey:@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self stopLoading:[httpTask element]];
            
        });
        
    }
    
    
}

-(void) vtHttpTaskDidLoaded:(id) httpTask{
    
    VTDOMElement * topElement = [httpTask topElement];

    
    if(topElement == [self topElement:nil] && [httpTask element] == nil){
        
        [topElement setAttributeValue:@"" forKey:@"loading"];
        
        [[httpTask element] setAttributeValue:@"" forKey:@"status"];
        
        NSString * documentVersion =  [[[(VTHttpTask *)httpTask response] allHeaderFields] valueForKey:@"VTDOMDocumentVersion"];
        
        if([documentVersion isEqualToString:VTDOMDocumentVersion]){
            
            
            NSString * filePath = [self documentFilePath];
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            
            NSString * dir = [filePath stringByDeletingLastPathComponent];
            
            if(![fileManager fileExistsAtPath:dir]){
                [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            [fileManager removeItemAtPath:filePath error:nil];
            
            [fileManager moveItemAtPath:[httpTask responseBody] toPath:filePath error:nil];
            
            [self didLoadedHTMLContent:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] element:[httpTask element]];
            
        }
        else {
            
            NSLog(@"%@",[[(VTHttpTask *)httpTask response] allHeaderFields] );
            
            [self didFailError:[NSError errorWithDomain:NSStringFromClass([self class]) code:VTURLDocumentControllerErrorCodeNotSupperDocumentVersion userInfo:[[(VTHttpTask *)httpTask response] allHeaderFields]] element:[httpTask element]];
            
        }
        
    }
    else if(topElement.document == self.document){
        
        [[httpTask element] setAttributeValue:@"" forKey:@"status"];
        
        NSString * documentVersion =  [[[(VTHttpTask *)httpTask response] allHeaderFields] valueForKey:@"VTDOMDocumentVersion"];
        
        VTDOMElement * element = [httpTask element];

        
        if([documentVersion isEqualToString:VTDOMDocumentVersion]){
            
            
            NSString * method = [element attributeValueForKey:@"method"];
            
            if([method isEqualToString:@"replace"]){
                
                VTDOMElement * parentElement = [element parentElement];
                
                NSArray * childs = [parentElement childs];
                
                NSInteger index = [childs indexOfObject:element];
                
                if(index != NSNotFound){
                    
                    NSString * name = [element attributeValueForKey:@"group"];
                    
                    NSInteger i = index;
                    
                    while(i < [childs count]){
                        VTDOMElement * el = [childs objectAtIndex:i];
                        if([name isEqualToString:[el attributeValueForKey:@"name"]]){
                            [el removeFromParentElement];
                        }
                        else{
                            i ++;
                        }
                    }
                    
                    VTDOMParse * parse = [[VTDOMParse alloc] init];
                    
                    [parse parseHTML:[httpTask responseBody] toElement:parentElement atIndex:index];
                    
                    [self.document applyStyleSheet:parentElement];
                    
                    [self documentLayout];
                }
                
            }
            else {
                
                for(VTDOMElement * el in [NSArray arrayWithArray:[element childs]]){
                    [el removeFromParentElement];
                }
                
                VTDOMParse * parse = [[VTDOMParse alloc] init];
                
                [parse parseHTML:[httpTask responseBody] toElement:element];
                
                [self.document applyStyleSheet:element];
                
                if([element booleanValueForKey:@"loadContent"]){
                    
                    [element layout];
                    
                    [self downloadImagesForElement:element];
                    
                    [self downloadImagesForView:_documentView];
                    
                }
                else {
                    [self documentLayout];
                }
                
                
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self stopLoading:element];
            
            [topElement setAttributeValue:@"" forKey:@"loading"];
        });
        
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


-(UIView *) vtDOMView:(VTDOMView *)view elementView:(VTDOMElement *)element viewClass:(Class) viewClass{
    if([self.delegate respondsToSelector:@selector(vtURLDocumentController:elementView:viewClass:)]){
        return [self.delegate vtURLDocumentController:self elementView:element viewClass:viewClass];
    }
    return nil;
}

-(void) vtDOMView:(VTDOMView *)view downloadImagesForElement:(VTDOMElement *)element{
    [self downloadImagesForElement:element];
}

-(void) vtDOMView:(VTDOMView *)view downloadImagesForView:(UIView *) forView{
    [self downloadImagesForView:forView];
}

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element{
    
    if([element isKindOfClass:[VTDOMStatusElement class]]){
        
        VTDOMElement * topElement = [self topElement:element];
        
        NSString * status = [(VTDOMStatusElement *) element status];
        
        if([status isEqualToString:@"topover"] || [status isEqualToString:@"leftover"]){
            
            if(! [topElement booleanValueForKey:@"loading"]){
                
                [topElement setAttributeValue:@"true" forKey:@"loading"];
                [element setAttributeValue:@"loading" forKey:@"status"];
                
                dispatch_async(dispatch_get_current_queue(), ^{
                    [self startLoading:element];
                });
                
                NSString * url  = [topElement attributeValueForKey:@"url"];
                
                if(url){
                    
                    NSString * query = [element attributeValueForKey:@"query"];
                    
                    NSMutableDictionary * queryValues = [NSMutableDictionary dictionaryWithDictionary:[NSURL decodeQuery:query]];
                    
                    if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
                        [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
                    }
                    
                    [self reloadElement:topElement queryValues:queryValues];
                    
                }
                else {
                    
                    NSString * url = [element attributeValueForKey:@"url"];
                    
                    if(url){
                        
                        NSMutableDictionary * queryValues = [NSMutableDictionary dictionary];
                        
                        if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
                            [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
                        }
                        
                        self.documentURL = [NSURL URLWithString:url relativeToURL:self.documentURL queryValues:queryValues];
                    }
                    
                    [self reloadData];
                }
            }
        }
        else if([status isEqualToString:@"right"] || [status isEqualToString:@"bottom"] || [status isEqualToString:@"bottomover"] || [status isEqualToString:@"rightover"]){
            
            if(! [topElement booleanValueForKey:@"loading"]){
                
                [topElement setAttributeValue:@"true" forKey:@"loading"];
                
                NSMutableDictionary * queryValues = [NSMutableDictionary dictionary];
                
                if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
                    [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
                }
                
                [self reloadElement:element queryValues:queryValues];
                
                [(VTDOMStatusElement *) element setStatus:@"loading"];
            }
        }
        
    }
    else {
        
        NSString * actionName = [element attributeValueForKey:@"action-name"];
        
        if([actionName isEqualToString:@"reloadData"]){
            
            NSString * url = [element attributeValueForKey:@"url"];
            
            if(url){
               
                NSMutableDictionary * queryValues = [NSMutableDictionary dictionary];
                
                if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
                    [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
                }
                
                self.documentURL = [NSURL URLWithString:url relativeToURL:self.documentURL queryValues:queryValues];
            }
            
            [self reloadData];
            
        }
        else if([actionName isEqualToString:@"reload-url"]){
            
            NSMutableDictionary * queryValues = [NSMutableDictionary dictionary];
            
            if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
                [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
            }
            
            [self reloadElement:element queryValues:queryValues];
            
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
        [httpTask setTopElement:[self topElement:element]];
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
        
        NSLog(@"%@",[[request URL] absoluteString]);
        
    }
    
}

-(void) startLoading:(VTDOMElement *)element rect:(CGRect) rect{
    
    if([element isKindOfClass:[VTDOMContainerElement class]]){
        
        UIScrollView * contentView = [(VTDOMContainerElement *) element contentView];
        
        if(rect.origin.y < 0 || rect.origin.x < 0){
            [contentView setContentOffset:rect.origin animated:YES];
        }
        
    }
    else if(element.parentElement){
        [self startLoading:element.parentElement rect:rect];
    }
    
}

-(void) startLoading:(VTDOMElement *) element{
    
    [self startLoading:element rect:[element frame]];

}

-(void) stopLoading:(VTDOMElement *) element{
    

    if([element isKindOfClass:[VTDOMContainerElement class]]){
        
        UIScrollView * contentView = [(VTDOMContainerElement *) element contentView];
        
        if(contentView.contentOffset.y < 0 || contentView.contentOffset.x < 0){
            [contentView setContentOffset:CGPointZero animated:YES];
        }
        
    }
    else if(element.parentElement){
        [self stopLoading:element.parentElement];
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

-(void) documentWillLoad{
    
}

-(void) documentDidLoad{
    
    if([self.delegate respondsToSelector:@selector(vtURLDocumentControllerDidDocumentLoaded:)]){
        [self.delegate vtURLDocumentControllerDidDocumentLoaded:self];
    }
}

-(void) documentDidVisable{
    
}

-(void) documentWillLayout{
    
}

-(void) documentDidLayout{
    
}

-(void) documentLayout{
    
    [self documentWillLayout];
    
    [_documentView setElement:_document.rootElement];
    
    [self downloadImagesForElement:_document.rootElement];
   
    [self downloadImagesForView:_documentView];
    
    [self documentDidLayout];
    
}

-(void) vtDOMView:(VTDOMView *)view loadContentForElement:(VTDOMElement *) element{
    
    NSMutableDictionary * queryValues = [NSMutableDictionary dictionaryWithCapacity:4];
    
    if([self.delegate respondsToSelector:@selector(vtURLDocumentController:willReloadElement:queryValues:)]){
        [self.delegate vtURLDocumentController:self willReloadElement:element queryValues:queryValues];
    }
    
    [self reloadElement:element queryValues:queryValues];
    
}

@end
