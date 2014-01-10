//
//  vmVariant.m
//  vmRuntimeLib
//
//  Created by 张海龙 张海龙 on 11-11-14.
//  Copyright (c) 2011年 hailong.org. All rights reserved.
//

#include "hconfig.h"
#include "hvermin_runtime_variant.h"
#include "hbuffer.h"
#include "hvermin_object.h"
#import "vmVariant.h"


NSString * vmVariantToNSString(vmRuntimeContext context,vmVariant value){
    InvokeTickBegin
    hbuffer_t str = buffer_alloc(128, 128);
    vmVariantToString(context, value, str);
    NSString * rs = [NSString stringWithCString:buffer_to_str(str) encoding:NSUTF8StringEncoding];
    buffer_dealloc(str);
    return rs;
}

vmVariant NSObjectToVariant(vmRuntimeContext context,id object){
    vmVariant rs = {vmVariantTypeVoid,0};
    InvokeTickBegin
    if([object isKindOfClass:[NSString class]]){
        rs = vmStringAlloc(context, [object UTF8String]);
    }
    else if([object isKindOfClass:[NSNumber class]]){
        rs.type = vmVariantTypeDouble;
        rs.value.doubleValue = [object doubleValue];
    }
    else if([object isKindOfClass:[NSArray class]]){
        rs = vmArrayAlloc(context);
        for(id v in object){
            vmArrayAdd(context, rs.value.objectValue, NSObjectToVariant(context, v));
        }
    }
    else if([object isKindOfClass:[NSDictionary class]]){
        NSEnumerator  *keyEnum = [object keyEnumerator];
        NSString * key;
        rs = vmDictionaryAlloc(context);
        while((key = [keyEnum nextObject])){
            vmDictionaryPut(context, rs.value.objectValue, [key UTF8String], NSObjectToVariant(context,[object valueForKey:key]));
        }
    }
    
    return rs;
}

CGSize vmVariantToCGSize(vmRuntimeContext context,vmVariant value){
    CGSize size = CGSizeZero;
    vmVariant v;
    InvokeTickBegin
    if((value.type & vmVariantTypeObject) && value.value.objectValue){
        v = vmObjectGetProperty(context, value.value.objectValue->vmClass, value.value.objectValue, vmRuntimeContextGetUniqueKey(context, "width"));
        size.width = vmVariantToDouble(context, v);
        v = vmObjectGetProperty(context, value.value.objectValue->vmClass, value.value.objectValue, vmRuntimeContextGetUniqueKey(context, "height"));
        size.height = vmVariantToDouble(context, v);
    }
    return size;
}

CGPoint vmVariantToCGPoint(vmRuntimeContext context,vmVariant value){
    CGPoint point = CGPointZero;
    vmVariant v;
    InvokeTickBegin
    if((value.type & vmVariantTypeObject) && value.value.objectValue){
        v = vmObjectGetProperty(context, value.value.objectValue->vmClass, value.value.objectValue, vmRuntimeContextGetUniqueKey(context, "x"));
        point.x = vmVariantToDouble(context, v);
        v = vmObjectGetProperty(context, value.value.objectValue->vmClass, value.value.objectValue, vmRuntimeContextGetUniqueKey(context, "y"));
        point.y = vmVariantToDouble(context, v);
    }
    return point;
}
