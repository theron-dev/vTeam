//
//  VTJSON.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTJSON : NSObject

+(id) decodeText:(NSString *) text;

+(NSString *) encodeObject:(id) object;

@end
