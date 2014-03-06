//
//  VTDOMParse.m
//  vTeam
//
//  Created by zhang hailong on 13-8-13.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMParse.h"
#import "VTDOMElement.h"
#import "VTDOMDocument.h"

#include "hconfig.h"
#include "hxml_scanf.h"
#include "hcss_scanf.h"

#import "VTDOMImageElement.h"
#import "VTDOMLabelElement.h"
#import "VTDOMRichElement.h"
#import "VTDOMActionElement.h"
#import "VTDOMViewElement.h"
#import "VTDOMPageScrollElement.h"
#import "VTDOMHScrollElement.h"
#import "VTDOMVScrollElement.h"
#import "VTDOMLinkElement.h"
#import "VTDOMStatusElement.h"
#import "VTDOMTableElement.h"
#import "VTDOMBRElement.h"

typedef struct _VTDOMParseScanf {
    hxml_scanf_t base;
    VTDOMParse * parse;
    VTDOMElement * toElement;
    NSInteger index;
} VTDOMParseScanf;

static hany VTDOMParse_scanf_element_new(struct _hxml_scanf_t * xml,hcchar * name,hcchar * ns, InvokeTickDeclare){
    
    VTDOMParseScanf * s = (VTDOMParseScanf *) xml;

    return [s->parse newElement:name ? [NSString stringWithCString:name encoding:NSUTF8StringEncoding] : nil
                             ns:ns ? [NSString stringWithCString:ns encoding:NSUTF8StringEncoding] : nil];
}

static void VTDOMParse_scanf_element_attr_set(struct _hxml_scanf_t * xml,hany element,hcchar * key,hcchar * value,InvokeTickDeclare){
    if(key && value){
        VTDOMElement * el = (VTDOMElement *) element;
        [el setAttributeValue:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
    }
}

static void VTDOMParse_scanf_element_child_add(struct _hxml_scanf_t * xml,hany element,hany child,InvokeTickDeclare){
    VTDOMParseScanf * scan = (VTDOMParseScanf *) xml;
    VTDOMElement * el = (VTDOMElement *) element;
    if(el == scan->toElement){
        [el insertElement:(VTDOMElement *) child atIndex:scan->index ++];
    }
    else{
        [el addElement:(VTDOMElement *) child];
    }
}

static hbool VTDOMParse_scanf_element_is_empty(struct _hxml_scanf_t * xml,hany element,InvokeTickDeclare){
    return [[(VTDOMElement *) element childs] count] == 0;
}

static void VTDOMParse_scanf_element_text_set(struct _hxml_scanf_t * xml,hany element,hcchar * text,InvokeTickDeclare){
    if(text){
        [(VTDOMElement *) element setText:[NSString stringWithCString:text encoding:NSUTF8StringEncoding]];
    }
}

static hbool VTDOMParse_scanf_tag_has_children(struct _hxml_scanf_t * xml,hcchar * name,hcchar * ns,InvokeTickDeclare){
    return (!ns || * ns == '\0' ) && strcmp(name, "br") != 0 && strcmp(name, "wbr") != 0;
}

static void VTDOMParse_scanf_element_release(struct _hxml_scanf_t * xml,hany element,InvokeTickDeclare){
    
}


static hany VTDOMParseCSS_style_new(struct _hcss_scanf_t * css,hcchar * name, InvokeTickDeclare){
    VTDOMStyle * style = [[VTDOMStyle alloc] init];
    style.name = name ? [NSString stringWithCString:name encoding:NSUTF8StringEncoding] : nil;
    return [style autorelease];
}

static void VTDOMParseCSS_style_attr_set(struct _hcss_scanf_t * css,hany style,hcchar * key,hcchar * value,InvokeTickDeclare){
    [(VTDOMStyle *) style setStringValue:value ? [NSString stringWithCString:value encoding:NSUTF8StringEncoding] : nil forKey:key ? [NSString stringWithCString:key encoding:NSUTF8StringEncoding] : @""];
}

static void VTDOMParseCSS_style_release(struct _hcss_scanf_t * css,hany style,InvokeTickDeclare){
    
}

static void VTDOMParseCSS_style_sheet_add(struct _hcss_scanf_t * css,hany styleSheet,hany style,InvokeTickDeclare){
    [(VTDOMStyleSheet *) styleSheet addStyle:(VTDOMStyle *) style];
}

static hcss_scanf_t VTDOMParseCSSScanf = {
    VTDOMParseCSS_style_new,
    VTDOMParseCSS_style_attr_set,
    VTDOMParseCSS_style_sheet_add,
    VTDOMParseCSS_style_release,
};


@implementation VTDOMParse

-(VTDOMElement *) newElement:(NSString *) name ns:(NSString *) ns{
    Class elementClass = [VTDOMElement class];
    
    if([name isEqualToString:@"img"]){
        elementClass = [VTDOMImageElement class];
    }
    else if([name isEqualToString:@"label"]){
        elementClass = [VTDOMLabelElement class];
    }
    else if([name isEqualToString:@"rich"]){
        elementClass = [VTDOMRichElement class];
    }
    else if([name isEqualToString:@"action"]){
        elementClass = [VTDOMActionElement class];
    }
    else if([name isEqualToString:@"view"]){
        elementClass = [VTDOMViewElement class];
    }
    else if([name isEqualToString:@"page"]){
        elementClass = [VTDOMPageScrollElement class];
    }
    else if([name isEqualToString:@"hscroll"]){
        elementClass = [VTDOMHScrollElement class];
    }
    else if([name isEqualToString:@"vscroll"]){
        elementClass = [VTDOMVScrollElement class];
    }
    else if([name isEqualToString:@"container"]){
        elementClass = [VTDOMContainerElement class];
    }
    else if([name isEqualToString:@"status"]){
        elementClass = [VTDOMStatusElement class];
    }
    else if([name isEqualToString:@"a"]){
        elementClass = [VTDOMLinkElement class];
    }
    else if([name isEqualToString:@"table"]){
        elementClass = [VTDOMTableElement class];
    }
    else if([name isEqualToString:@"br"]){
        elementClass = [VTDOMBRElement class];
    }
    
    VTDOMElement * element = [[elementClass alloc] init];
    element.name = name;
    element.ns = ns;
    return [element autorelease];
}

-(BOOL) parseHTML:(NSString *) html toElement:(VTDOMElement *) element atIndex:(NSInteger) index{
    VTDOMParseScanf scanf = {{
        VTDOMParse_scanf_element_new,
        VTDOMParse_scanf_element_attr_set,
        VTDOMParse_scanf_element_child_add,
        VTDOMParse_scanf_element_is_empty,
        VTDOMParse_scanf_element_text_set,
        VTDOMParse_scanf_tag_has_children,
        VTDOMParse_scanf_element_release
    },self, element, index};
    
    return hxml_scanf(&scanf.base, [html UTF8String], element, InvokeTickRoot) ? YES: NO;
}

-(BOOL) parseHTML:(NSString *) html toElement:(VTDOMElement *) element{
    return [self parseHTML:html toElement:element atIndex:0];
}

-(BOOL) parseHTML:(NSString *) html toDocument:(VTDOMDocument *) document{
    VTDOMElement * rootElement = [[[VTDOMElement alloc] init] autorelease];
    rootElement.name = @"__ROOT__";
    if([self parseHTML:html toElement:rootElement]){
        if([rootElement.childs count] == 1){
            rootElement = [[rootElement childs] objectAtIndex:0];
            [rootElement retain];
            [rootElement removeFromParentElement];
            [document setRootElement:rootElement];
            [rootElement release];
        }
        else{
            [document setRootElement:rootElement];
        }
        return YES;
    }
    return NO;
}

-(BOOL) parseCSS:(NSString *) css toStyleSheet:(VTDOMStyleSheet *) styleSheet{
    return hcss_scanf(&VTDOMParseCSSScanf, [css UTF8String], styleSheet, InvokeTickRoot) ? YES: NO;
}

@end
