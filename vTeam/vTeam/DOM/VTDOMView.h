//
//  VTDOMView.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTDOMElement+Render.h>

@interface VTDOMView : UIView<VTDOMElementDelegate>

@property(nonatomic,assign) IBOutlet id delegate;
@property(nonatomic,retain) VTDOMElement * element;
@property(nonatomic,assign,getter = isAllowAutoLayout) BOOL allowAutoLayout;

@end

@protocol VTDOMViewDelegate

@optional

-(void) vtDOMView:(VTDOMView *) view doActionElement:(VTDOMElement *) element;

-(void) vtDOMView:(VTDOMView *)view downloadImagesForElement:(VTDOMElement *) element;

-(void) vtDOMView:(VTDOMView *)view downloadImagesForView:(UIView *) forView;

-(UIView *) vtDOMView:(VTDOMView *)view elementView:(VTDOMElement *)element viewClass:(Class) viewClass;

@end
