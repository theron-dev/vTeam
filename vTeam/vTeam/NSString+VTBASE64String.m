//
//  NSString+VTBASE64String.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+VTBASE64String.h"

#import "NSData+VTBASE64String.h"

@implementation NSString (VTBASE64String)

-(NSString *) vtBASE64String{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] vtBASE64String];
}

@end
