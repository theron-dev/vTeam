//
//  IVTViewEntity.h
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTElement;

@protocol IVTViewEntity <NSObject>

-(void) elementDoAction:(id<IVTViewEntity>) viewEntity element:(VTElement *) element;

-(void) elementDoNeedsDisplay:(VTElement *) element;

-(UIView *) elementViewOf:(VTElement *) element viewClass:(Class) viewClass;

-(void) elementLayoutView:(VTElement *) element view:(UIView *) view;

-(void) elementVisable:(id<IVTViewEntity>) viewEntity element:(VTElement *) element;

@end
