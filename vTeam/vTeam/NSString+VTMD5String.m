//
//  NSString+VTMD5String.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+VTMD5String.h"

#import "NSData+VTMD5String.h"

@implementation NSString (VTMD5String)

-(NSString *) vtMD5String{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] vtMD5String];
}

@end
