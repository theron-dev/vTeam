//
//  IVTLayoutElement.h
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IVTLayoutElement <NSObject>

@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,readonly) UIEdgeInsets padding;
@property(nonatomic,readonly) UIEdgeInsets margin;
@property(nonatomic,readonly,getter=isLayouted) BOOL layouted;

-(CGSize) layoutChildren:(UIEdgeInsets) padding;

-(CGSize) layout:(CGSize) size;

-(CGSize) layout;

@end
