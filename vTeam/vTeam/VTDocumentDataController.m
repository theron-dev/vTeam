//
//  VTDocumentDataController.m
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDocumentDataController.h"

#import "VTDOMElement+Layout.h"

#import "NSString+VTDOMSource.h"

#import "VTDOMImageElement.h"

@implementation VTDocumentDataController

@synthesize html = _html;
@synthesize dataItem = _dataItem;
@synthesize bundle = _bundle;

-(void) dealloc{
    [_bundle release];
    [_dataItem release];
    [_html release];
    [super dealloc];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [self.headerCells count]){
        return [[self.headerCells objectAtIndex:indexPath.row] frame].size.height;
    }
    
    if(indexPath.row >= [self.dataSource count] + [self.headerCells count]){
        return [[self.footerCells objectAtIndex:indexPath.row
                 - [self.dataSource count] - [self.headerCells count]] frame].size.height;
    }
    
    VTDOMDocument * document = [self documentByIndexPath:indexPath];
    
    return [[document rootElement] frame].size.height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < [self.headerCells count]){
        return [self.headerCells objectAtIndex:indexPath.row];
    }
    
    if(indexPath.row >= [self.dataSource count] + [self.headerCells count]){
        return [self.footerCells objectAtIndex:indexPath.row
                - [self.dataSource count] - [self.headerCells count]];
    }
    
    NSString * identifier = self.reusableCellIdentifier;
    
    if(identifier == nil){
        identifier = @"Document";
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        CGSize size = cell.contentView.bounds.size;
        
        VTDOMView * documentView = [[VTDOMView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        [documentView setBackgroundColor:[UIColor clearColor]];
        [documentView setDelegate:self];
        [documentView setAllowAutoLayout:NO];
        [documentView setTag:100];
        [documentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        [cell.contentView addSubview:documentView];
        
        [documentView release];
        
    }
    
    VTDOMView * documentView = (VTDOMView *) [cell.contentView viewWithTag:100];
    
    VTDOMDocument * document = [self documentByIndexPath:indexPath];
    
    [documentView setElement:[document rootElement]];
    
    if([document rootElement]){
        dispatch_async(dispatch_get_current_queue(), ^{
            [self downloadImagesForElement:[document rootElement]];
        });
    }
    
    return cell;
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


-(NSString *) htmlContentByIndexPath:(NSIndexPath *) indexPath{
    
    self.dataItem = [self dataObjectByIndexPath:indexPath];
    
    NSBundle * bundle = self.bundle;
    
    if(bundle == nil){
        bundle = [NSBundle mainBundle];
    }
    
    NSString * htmlContent = [NSString stringWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:self.html] encoding:NSUTF8StringEncoding error:nil];
    
    htmlContent = [htmlContent htmlStringByDOMSource:self];
    
    return htmlContent;
    
}

-(void) document:(VTDOMDocument *) document didLoadedDataObject:(id) dataObject;{
    
}

-(void) document:(VTDOMDocument *) document willLoadDataObject:(id) dataObject{
    
}

-(VTDOMDocument *) documentByIndexPath:(NSIndexPath *) indexPath{
    
    id data = [self dataObjectByIndexPath:indexPath];
    
    if([data isKindOfClass:[NSMutableDictionary class]]){
        
        VTDOMDocument * document = [data valueForKey:@"__document__"];
        
        if(document == nil){
            
            document = [[[VTDOMDocument alloc] init] autorelease];
            
            VTDOMParse * parse = [[VTDOMParse alloc] init];
            [parse parseHTML:[self htmlContentByIndexPath:indexPath] toDocument:document];
            [parse release];
            
            [self document:document willLoadDataObject:data];
            
            [document setStyleSheet:[self.context domStyleSheet]];
            
            [data setValue:document forKey:@"__document__"];
            
            document.indexPath = indexPath;

            [self document:document didLoadedDataObject:data];
            
            [[document rootElement] layout:CGSizeMake(self.tableView.bounds.size.width, INT_MAX)];
            
        }
        
        return document;
    }
    
    return nil;
}

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element{
    if([self.delegate respondsToSelector:@selector(vtDocumentDataController:element:doAction:)]){
        if([element conformsToProtocol:@protocol(IVTAction)]) {
            [self.delegate vtDocumentDataController:self element:element doAction:(id)element];
        }
        else{
            [self.delegate vtDocumentDataController:self
                                            element:element doAction:nil];
        }
    }
}

-(id) dataObjectByIndexPath:(NSIndexPath *) indexPath{
    return [self.dataSource dataObjectAtIndex:indexPath.row - [self.headerCells count]];
}

-(void) removeDocumentByIndexPath:(NSIndexPath *) indexPath{
    
    id data = [self dataObjectByIndexPath:indexPath];
    
    if([data isKindOfClass:[NSMutableDictionary class]]){
        [data removeObjectForKey:@"__document__"];
    }
}

-(void) layoutDocumentByIndexPath:(NSIndexPath *) indexPath{
    
    id data = [self dataObjectByIndexPath:indexPath];
    
    if([data isKindOfClass:[NSMutableDictionary class]]){
        
        VTDOMDocument * document = [data valueForKey:@"__document__"];
        
        if(document){
            [[document rootElement] layout:CGSizeMake(self.tableView.bounds.size.width, INT_MAX)];
        }
    }
}

@end
