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

#define VTUIPlatform_iPhone5_iOS7   @"iPhone5_iOS7"
#define VTUIPlatform_iPhone_iOS7    @"iPhone_iOS7"
#define VTUIPlatform_iPad_iOS7      @"iPad_iOS7"
#define VTUIPlatform_iPhone5        @"iPhone5"
#define VTUIPlatform_iPhone         @"iPhone"
#define VTUIPlatform_iPad           @"iPad"
#define VTUIPlatform_iOS7           @"iOS7"

typedef void ( ^ VTUIContextResultsCallback )(id resultsData,id sender);

@protocol IVTUIContext <IVTServiceContext>

@property(nonatomic,readonly) VTStyleSheet * styleSheet;
@property(nonatomic,retain) IBOutlet VTStyleController * styleController;
@property(nonatomic,readonly) VTDOMStyleSheet * domStyleSheet;

-(id) getViewController:(NSURL *) url basePath:(NSString *) basePath;

-(id) focusValueForKey:(NSString *) key;

-(void) setFocusValue:(id) value forKey:(NSString *) key;

-(id) rootViewController;

-(void) loadDOMStyleSheet:(NSString *) cssContent;

-(BOOL) hasWaitResultsData;

-(void) setResultsData:(id) resultsData sender:(id) sender;

-(void) setResultsData:(id) resultsData;

-(void) waitResultsData:(VTUIContextResultsCallback) callback;

-(VTUIContextResultsCallback) resultsCallback;

@end
