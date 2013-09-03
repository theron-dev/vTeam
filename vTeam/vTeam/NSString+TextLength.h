//
//  NSString+TextLength.h
//  vTeam
//
//  Created by zhang hailong on 13-9-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TextLength)

-(NSUInteger) textLength;

-(NSUInteger) textIndexOfLength:(NSUInteger) textLength;

-(NSString *) reverseString;

@end
