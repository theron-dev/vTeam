//
//  vmDOMElement.h
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDOMElement.h>

#include "hvermin_runtime.h"

extern vmClassBase vmDOMElementClass;

typedef struct _vmDOMElement{
    vmObject base;
    VTDOMElement * element;
    struct{
        vmUniqueKey attr;
        vmUniqueKey css;
        vmUniqueKey val;
        vmUniqueKey append;
        vmUniqueKey remove;
        vmUniqueKey length;
        vmUniqueKey childAt;
        vmUniqueKey parent;
    }uniqueKeys;
}vmDOMElement;

vmVariant vmDOMElementAlloc(vmRuntimeContext context,VTDOMElement * element,InvokeTickDeclare);