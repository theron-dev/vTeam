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

@property(nonatomic,weak) id delegate;
@property(nonatomic,retain) VTElement * element;
@property(nonatomic,assign,getter = isAllowAutoLayout) BOOL allowAutoLayout;

@end

@protocol VTDocumentViewDelegate <NSObject>

@optional

-(void) documentView:(VTDocumentView *) documentView onActionViewEntity:(id<IVTViewEntity>) viewEntity element:(VTElement *) element;

-(void) documentView:(VTDocumentView *) documentView onVisableViewEntity:(id<IVTViewEntity>) viewEntity element:(VTElement *) element;

@end

