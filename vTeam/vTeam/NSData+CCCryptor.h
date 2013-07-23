//
//  NSData+CCCryptor.h
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCrypto.h>

@interface NSData (CCCryptor)

-(NSData *) CCCryptorEncryptedUsingAlgorithm: (CCAlgorithm) algorithm key:(id) key;

-(NSData *) CCCryptorDecryptedUsingAlgorithm: (CCAlgorithm) algorithm key:(id) key;

-(NSData *) AES256EncryptWithKey:(NSString *)key;

-(NSString*) toHexString;

@end
