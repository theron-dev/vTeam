//
//  VTViewController.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/IVTUIViewController.h>

@interface VTViewController : UIViewController<IVTUIViewController>

-(IBAction) doAction:(id)sender;

-(void) downloadImagesForView:(UIView *) view;

-(void) loadImagesForView:(UIView *) view;

-(void) cancelDownloadImagesForView:(UIView *) view;



@end
