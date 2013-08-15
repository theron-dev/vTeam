//
//  VTDocumentViewController.h
//  vTeam
//
//  Created by zhang hailong on 13-8-15.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface VTDocumentViewController : VTViewController<VTDOMViewDelegate>

@property(nonatomic,retain) NSString * html;
@property(nonatomic,retain) IBOutlet VTDOMView * documentView;
@property(nonatomic,retain) VTDOMDocument * document;

-(void) reloadData;

-(NSString *) htmlContent;

@end
