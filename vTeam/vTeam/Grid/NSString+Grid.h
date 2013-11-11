//
//  NSString+Grid.h
//  vTeam
//
//  Created by zhang hailong on 13-11-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Grid)

-(NSString *) expressionOfKeyPath:(NSString *) keyPath data:(id) data;

-(NSString *) expressionOfData:(id) data;

@end
