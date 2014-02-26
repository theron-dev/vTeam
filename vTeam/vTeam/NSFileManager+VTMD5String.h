//
//  NSFileManager+VTMD5String.h
//  vTeam
//
//  Created by zhang hailong on 14-2-26.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (VTMD5String)

-(NSString *) vtMD5StringAtPath:(NSString *) filePath;

@end
