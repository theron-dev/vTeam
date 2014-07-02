//
//  VTCanvasElement.h
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vDocument/VTLayoutElement.h>
#import <vDocument/IVTCanvasElement.h>

@interface VTCanvasElement : VTLayoutElement<IVTCanvasElement>

@property(nonatomic,readonly) UIColor * backgroundColor;
@property(nonatomic,readonly) UIColor * borderColor;
@property(nonatomic,readonly) CGFloat borderWidth;

-(void) onDrawBackgroundInContext:(CGContextRef) context;

-(void) onDrawInContext:(CGContextRef) context;

-(void) onDrawBorderInContext:(CGContextRef) context;

@end
