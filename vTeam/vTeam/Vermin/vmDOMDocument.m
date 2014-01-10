//
//  vmDOMDocument.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#include "hconfig.h"
#import "vmDOMDocument.h"
#import "vmDOMElement.h"
#import "VTDOMElement.h"

#include "hvermin_object.h"
#include "hvermin_runtime_variant.h"
#include "hbuffer.h"

#import "vmVariant.h"

@implementation vmVTDOMDocument

@synthesize vmObject = _vmObject;

@end
/**
 
 Return : Void or Throwable
 */

vmVariant vmDOMDocumentClassInitCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmVariantList args,InvokeTickDeclare){
    vmVariant rs=  {vmVariantTypeVoid,0};
    
    vmDOMDocument * document = (vmDOMDocument *) object;
    
    if(vmVariantListCount(args) > 0){
        
        vmVariant v = vmVariantListGet(args, 0);
        
        if((v.type & vmVariantTypeThrowable) && (v.type & vmVariantTypeObject)){
            document->document = [(id)v.value.objectValue retain];
        }
        
    }
    
    if(document->document == nil){
        document->document = [[vmVTDOMDocument alloc] init];
    }
    
    [document->document setVmObject:(vmObject *)document];
    
    document->uniqueKeys.rootElement = vmRuntimeContextGetUniqueKey(context, "rootElement");
    document->uniqueKeys.getElementById = vmRuntimeContextGetUniqueKey(context, "getElementById");
    document->uniqueKeys.applySheetStyle = vmRuntimeContextGetUniqueKey(context, "applySheetStyle");
    
    return rs;
}

/**
 
 Return : Void or Throwable
 */

vmVariant vmDOMDocumentClassDestroyCallback(vmRuntimeContext context, vmObject * object,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMDocument * document = (vmDOMDocument *) object;
    
    [document->document setVmObject:nil];
    [document->document release];
    document->document = nil;
    
    
    return rs;
}

/**
 
 Return : Void,Int16,Int32,Int64,Boolean,Double,Object or Throwable
 */

vmVariant vmDOMDocumentClassGetPropertyCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMDocument * document = (vmDOMDocument *) object;
    
    if(document->uniqueKeys.rootElement == name){
        
        VTDOMElement * el = [document->document rootElement];
        
        if(el){
            
            vmDOMElement * vel = [[el valueForKey:@"vmObject"] pointerValue];
            
            if(vel){
                rs.type = vmVariantTypeObject;
                rs.value.objectValue = (vmObject *) vel;
            }
            else{
                rs = vmDOMElementAlloc(context, el,InvokeTickArg);
            }
            
        }
        
    }
    else {
        return vmObjectClassGetPropertyCallback(context, clazz, object, name, InvokeTickArg);
    }
    
    return rs;
}


/**
 
 Return : Void or Throwable
 */

vmVariant vmDOMDocumentClassSetPropertyCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,vmVariant value,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    return rs;
}

/**
 
 Return : any
 */

vmVariant vmDOMDocumentClassInvokeCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,vmVariantList args,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMDocument * document = (vmDOMDocument *) object;
    
    if(document->uniqueKeys.getElementById == name){
        
        if(vmVariantListCount(args) > 0){
            
            hbuffer_t buf = buffer_alloc(32, 64);
            
            vmVariantToString(context, vmVariantListGet(args, 0), buf);
            
            NSString * key = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
            
            VTDOMElement * el = [document->document elementById:key];
            
            if(el){
                
                vmDOMElement * vel = [[el valueForKey:@"vmObject"] pointerValue];
                
                if(vel){
                    rs.type = vmVariantTypeObject;
                    rs.value.objectValue = (vmObject *) vel;
                }
                else{
                    rs = vmDOMElementAlloc(context, el,InvokeTickArg);
                }
                
            }
            
            buffer_dealloc(buf);
        }
       
    }
    else if(document->uniqueKeys.applySheetStyle == name){
        
        if(vmVariantListCount(args) >0){
            
            vmVariant v = vmVariantListGet(args, 0);
            
            if((v.type & vmVariantTypeObject ) && v.value.objectValue && vmRuntimeContextObjectIsKindClass(context, v.value.objectValue, (vmClass *) & vmDOMElementClass)){
                
                vmDOMElement * el = (vmDOMElement *) v.value.objectValue;
                
                [document->document applyStyleSheet:el->element];
                
            }
            
        }
        else{
            [document->document applyStyleSheet];
        }
        
    }
    else {
        return vmObjectClassInvokeCallback(context, clazz, object, name, args, InvokeTickArg);
    }
    
    
    return rs;
}

/**
 
 Return : Void
 */

void vmDOMDocumentClassPropertyNamesCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKeyList names,InvokeTickDeclare){
    
}


vmClassBase vmDOMDocumentClass = {vmClassTypeBase,sizeof(vmObject),vmDOMDocumentClassInitCallback,vmDOMDocumentClassDestroyCallback,vmDOMDocumentClassGetPropertyCallback,vmDOMDocumentClassSetPropertyCallback,vmDOMDocumentClassPropertyNamesCallback,vmDOMDocumentClassInvokeCallback};

vmVariant vmDOMDocumentAlloc(vmRuntimeContext context,VTDOMDocument * element,InvokeTickDeclare){
    
    vmVariantList args = vmVariantListAlloc();
    vmVariant v = {vmVariantTypeThrowable | vmVariantTypeObject,0};
    v.value.objectValue = (vmObject *) element;
    if(element){
        vmVariantListAdd(args, v);
    }
    
    vmVariant rs = vmObjectAlloc(context, (vmClass *) &vmDOMDocumentClass, args);
    
    vmVariantListDealloc(args);
    
    return rs;
}
