//
//  vmDOMElement.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#include "hconfig.h"
#import "vmDOMElement.h"

#import "VTDOMElement+Style.h"
#import "VTDOMParse.h"

#include "hvermin_object.h"
#include "hvermin_runtime_variant.h"
#include "hbuffer.h"

#import "vmVariant.h"

/**
 
 Return : Void or Throwable
 */

vmVariant vmDOMElementClassInitCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmVariantList args,InvokeTickDeclare){
    vmVariant rs=  {vmVariantTypeVoid,0};
    
    vmDOMElement * element = (vmDOMElement *) object;
    
    if(vmVariantListCount(args) == 1){
    
        vmVariant v = vmVariantListGet(args, 0);
        
        if((v.type & vmVariantTypeThrowable) && (v.type & vmVariantTypeObject)){
            element->element = [(id)v.value.objectValue retain];
        }
        
    }
    
    if(element->element == nil){
        element->element = [[VTDOMElement alloc] init];
    }
    
    [element->element setValue:[NSValue valueWithPointer:element] forKey:@"vmObject"];
    
    element->uniqueKeys.attr = vmRuntimeContextGetUniqueKey(context, "attr");
    element->uniqueKeys.css = vmRuntimeContextGetUniqueKey(context, "css");
    element->uniqueKeys.val = vmRuntimeContextGetUniqueKey(context, "val");
    element->uniqueKeys.append = vmRuntimeContextGetUniqueKey(context, "append");
    element->uniqueKeys.remove = vmRuntimeContextGetUniqueKey(context, "remove");
    element->uniqueKeys.length = vmRuntimeContextGetUniqueKey(context, "length");
    element->uniqueKeys.childAt = vmRuntimeContextGetUniqueKey(context, "childAt");
    element->uniqueKeys.parent = vmRuntimeContextGetUniqueKey(context, "parent");

    return rs;
}

/**
 
 Return : Void or Throwable
 */

vmVariant vmDOMElementClassDestroyCallback(vmRuntimeContext context, vmObject * object,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMElement * element = (vmDOMElement *) object;
    
    [element->element setValue:nil forKey:@"vmObject"];
    [element->element release];
    element->element = nil;
    
    
    return rs;
}

/**
 
 Return : Void,Int16,Int32,Int64,Boolean,Double,Object or Throwable
 */

vmVariant vmDOMElementClassGetPropertyCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMElement * element = (vmDOMElement *) object;
    
    if(element->uniqueKeys.length == name){

        rs.type = vmVariantTypeInt32;
        rs.value.int32Value = (hint32) [[element->element childs] count];
        
    }
    else if(element->uniqueKeys.parent == name){
        
        VTDOMElement * el = [element->element parentElement];
        
        if(el){
            
            vmDOMElement * vel = (vmDOMElement *) [[el valueForKey:@"vmObject"] pointerValue];
            
            if(vel){
                rs.type = vmVariantTypeObject;
                rs.value.objectValue = (vmObject *)vel;
            }
            else{
                rs = vmDOMElementAlloc(context, el, InvokeTickArg);
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

vmVariant vmDOMElementClassSetPropertyCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,vmVariant value,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    return rs;
}

/**
 
 Return : any
 */

vmVariant vmDOMElementClassInvokeCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKey name,vmVariantList args,InvokeTickDeclare){
    vmVariant rs = {vmVariantTypeVoid,0};
    
    vmDOMElement * element = (vmDOMElement *) object;
    
    if(element->uniqueKeys.childAt == name){
        
        vmVariant v = vmVariantListGet(args, 0);
        int index = vmVariantToInt32(context, v);
        
        NSArray * childs = [element->element childs];
        
        if(index >=0 && index < [childs count]){
            
            VTDOMElement * el = [childs objectAtIndex:index];
            vmDOMElement * vel = (vmDOMElement *) [[el valueForKey:@"vmObject"] pointerValue];
            
            if(vel){
                rs.type = vmVariantTypeObject;
                rs.value.objectValue = (vmObject *)vel;
            }
            else{
                rs = vmDOMElementAlloc(context, el, InvokeTickArg);
            }
        }
        
    }
    else if(element->uniqueKeys.attr == name){
        
        if(vmVariantListCount(args) >0){
            
            hbuffer_t buf = buffer_alloc(32, 64);
            
            vmVariantToString(context, vmVariantListGet(args,0), buf);
            
            NSString * key = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
            
            if(vmVariantListCount(args) > 1){
                
                id value = vmVariantToNSString(context, vmVariantListGet(args, 1));
                
                [element->element setAttributeValue:value forKey:key];
                
            }
            else{
                
                id value = [element->element attributeValueForKey:key];
                
                rs = NSObjectToVariant(context, value);
                
            }
            
            buffer_dealloc(buf);
        }
        
    }
    else if(element->uniqueKeys.css == name){
        
        if(vmVariantListCount(args) >0){
            
            hbuffer_t buf = buffer_alloc(32, 64);
            
            vmVariantToString(context, vmVariantListGet(args,0), buf);
            
            NSString * key = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
            
            id value = [element->element.style stringValueForKey:key];
            
            rs = NSObjectToVariant(context, value);
            
            buffer_dealloc(buf);
        }
    }
    else if(element->uniqueKeys.val == name){
        
        if(vmVariantListCount(args) >0){
            
            hbuffer_t buf = buffer_alloc(32, 64);
            
            vmVariantToString(context, vmVariantListGet(args,0), buf);
            
            NSString * key = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
            
            id value = [element->element stringValueForKey:key];
            
            rs = NSObjectToVariant(context, value);
            
            buffer_dealloc(buf);
        }
    }
    else if(element->uniqueKeys.append == name){
        
        if(vmVariantListCount(args) >0){
            
            vmVariant v = vmVariantListGet(args, 0);
            BOOL isOK = NO;
            
            if((v.type & vmVariantTypeObject) && v.value.objectValue){
                if(vmRuntimeContextObjectIsKindClass(context,v.value.objectValue,(vmClass *) & vmDOMElementClass)){
                    vmDOMElement * el = (vmDOMElement *) v.value.objectValue;
                    if(el->element){
                        [element->element addElement:el->element];
                        
                    }
                    isOK = YES;
                }
            }
            
            if(!isOK){
                
                hbuffer_t buf = buffer_alloc(256, 256);
                
                vmVariantToString(context, v, buf);
                
                if(buffer_length(buf)){
                    
                    VTDOMParse * parse = [[VTDOMParse alloc] init];
                    
                    NSString * htmlContent = [NSString stringWithCString:buffer_to_str(buf) encoding:NSUTF8StringEncoding];
                    
                    [parse parseHTML:htmlContent toElement:element->element];
                    
                    [parse release];
                    
                }
                
                buffer_dealloc(buf);
            }
            
        }
        
    }
    else if(element->uniqueKeys.remove == name){
        
        [element->element removeFromParentElement];
        
    }
    else {
        return vmObjectClassInvokeCallback(context, clazz, object, name, args, InvokeTickArg);
    }

    
    return rs;
}

/**
 
 Return : Void
 */

void vmDOMElementClassPropertyNamesCallback(vmRuntimeContext context,vmClass * clazz,vmObject * object,vmUniqueKeyList names,InvokeTickDeclare){
    
}


vmClassBase vmDOMElementClass = {vmClassTypeBase,sizeof(vmObject),vmDOMElementClassInitCallback,vmDOMElementClassDestroyCallback,vmDOMElementClassGetPropertyCallback,vmDOMElementClassSetPropertyCallback,vmDOMElementClassPropertyNamesCallback,vmDOMElementClassInvokeCallback};

vmVariant vmDOMElementAlloc(vmRuntimeContext context,VTDOMElement * element,InvokeTickDeclare){
    
    vmVariantList args = vmVariantListAlloc();
    vmVariant v = {vmVariantTypeThrowable | vmVariantTypeObject,0};
    v.value.objectValue = (vmObject *) element;
    if(element){
        vmVariantListAdd(args, v);
    }
    
    vmVariant rs = vmObjectAlloc(context, (vmClass *) &vmDOMElementClass, args);
    
    vmVariantListDealloc(args);
    
    return rs;
}
