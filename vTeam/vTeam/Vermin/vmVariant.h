//
//  vmVariant.h
//  vmRuntimeLib
//
//  Created by 张海龙 张海龙 on 11-11-14.
//  Copyright (c) 2011年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "hvermin.h"

NSString * vmVariantToNSString(vmRuntimeContext context,vmVariant value);

vmVariant NSObjectToVariant(vmRuntimeContext context,id object);

CGSize vmVariantToCGSize(vmRuntimeContext context,vmVariant value);

CGPoint vmVariantToCGPoint(vmRuntimeContext context,vmVariant value);
