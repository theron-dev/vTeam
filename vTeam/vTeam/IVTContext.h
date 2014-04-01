//
//  IVTContext.h
//  vTeam
//
//  Created by zhang hailong on 13-4-24.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IVTContext <NSObject>

-(NSBundle *) resourceBundle;

-(NSBundle *) temporaryBundle;

-(NSBundle *) documentBundle;

-(NSBundle *) applicationBundle;

// res:// tmp:// doc:// app://
-(NSString *) filePathWithFileURI:(NSString *) fileURI;

-(NSString *) fileURIWithFilePath:(NSString *) filePath;

@end
