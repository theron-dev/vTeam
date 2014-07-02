//
//  IVTCanvasElement.h
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vDocument/IVTLayoutElement.h>

@protocol IVTCanvasElement <IVTLayoutElement>

@property(nonatomic,readonly,getter=isHidden) BOOL hidden;
@property(nonatomic,readonly) CGFloat cornerRadius;

-(void) drawInContext:(CGContextRef) context;

@end
