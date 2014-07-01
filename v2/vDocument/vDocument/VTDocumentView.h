//
//  VTDocumentView.h
//  vDocument
//
//  Created by zhang hailong on 14-7-1.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vDocument/VTElement.h>
#import <vDocument/IVTViewEntity.h>

@interface VTDocumentView : UIView<IVTViewEntity>

@property(nonatomic,retain) VTElement * element;
@property(nonatomic,assign,getter = isAllowAutoLayout) BOOL allowAutoLayout;

@end
