//
//  NSString+TextLength.m
//  vTeam
//
//  Created by zhang hailong on 13-9-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+TextLength.h"

@implementation NSString (TextLength)

-(NSUInteger) textLength{
    
    int length = 0;
    NSUInteger stringLength = [self length];
    
    for (int i = 0; i < stringLength; i++) {
        unichar character = [self characterAtIndex:i];
        if (isblank(character)) {
            length++;
        } else if (isascii(character)) {
            length++;
        } else {
            length+= 2;
        }
    }
    
    return length;
}

-(NSUInteger) textIndexOfLength:(NSUInteger) textLength{
    
    int length = 0;
    NSUInteger stringLength = [self length];
    
    for (int i = 0; i < stringLength; i++) {
        unichar character = [self characterAtIndex:i];
        if (isblank(character)) {
            length++;
        } else if (isascii(character)) {
            length++;
        } else {
            length+= 2;
        }
        if(length >= textLength){
            return i;
        }
    }
    
    return stringLength;
}

- (NSString *)reverseString {
    NSMutableString *reversedString = [[NSMutableString alloc] init];
    NSRange fullRange = [self rangeOfString:self];
    NSStringEnumerationOptions enumerationOptions = (NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences);
    [self enumerateSubstringsInRange:fullRange options:enumerationOptions usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    return reversedString;
}

@end
