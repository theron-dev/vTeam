//
//  vmDOMDocument.h
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDOMDocument.h>

#include "hvermin_runtime.h"

@interface vmVTDOMDocument : VTDOMDocument

@property(nonatomic,assign) vmObject * vmObject;

@end

extern vmClassBase vmDOMDocumentClass;

typedef struct _vmDOMDocument{
    vmObject base;
    vmVTDOMDocument * document;
    struct{
        vmUniqueKey rootElement;
        vmUniqueKey getElementById;
        vmUniqueKey applySheetStyle;
    }uniqueKeys;
}vmDOMDocument;

vmVariant vmDOMDocumentAlloc(vmRuntimeContext context,VTDOMDocument * element,InvokeTickDeclare);

