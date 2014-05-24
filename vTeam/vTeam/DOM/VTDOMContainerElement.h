//
//  VTDOMContainerElement.h
//  vTeam
//
//  Created by zhang hailong on 14-2-16.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTDOMViewElement.h>

@interface VTDOMContainerElement : VTDOMViewElement<UIScrollViewDelegate>

@property(nonatomic,readonly) UIScrollView * contentView;

-(void) reloadData;

-(BOOL) isVisableRect:(CGRect) frame;

-(CGRect) frameInElement:(VTDOMElement *) element;

-(void) didVisableItemView:(UIView *) itemView element:(VTDOMElement *) element atIndex:(NSInteger) index;

-(void) didContainerDidAppera;

-(void) didContainerDidDispaaer;

@end
