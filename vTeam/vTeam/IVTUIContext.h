//
//  IVTUIContext.h
//  vTeam
//
//  Created by zhang hailong on 13-4-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/IVTServiceContext.h>
#import <vTeam/VTStyleSheet.h>
#import <vTeam/VTDOMStyleSheet.h>

@protocol IVTUIContext <IVTServiceContext>

@property(nonatomic,readonly) VTStyleSheet * styleSheet;
@property(nonatomic,retain) IBOutlet VTStyleController * styleController;
@property(nonatomic,readonly) VTDOMStyleSheet * domStyleSheet;

-(id) getViewController:(NSURL *) url basePath:(NSString *) basePath;

-(id) focusValueForKey:(NSString *) key;

-(void) setFocusValue:(id) value forKey:(NSString *) key;

-(id) rootViewController;

-(void) loadDOMStyleSheet:(NSString *) cssContent;

@end
