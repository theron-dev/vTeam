//
//  NSData+CCCryptor.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSData+CCCryptor.h"

@implementation NSData (CCCryptor)

static NSData * NSDataCCCryptorKey(CCAlgorithm algorithm, id key){
    
    NSMutableData * dKey = nil;
    
    if([key isKindOfClass:[NSData class]]){
        dKey = [key mutableCopy];
    }
    else if([key isKindOfClass:[NSString class]]){
        dKey = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    else{
        dKey = [[[NSString stringWithFormat:@"%@",key] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    NSUInteger keyLength = [dKey length];
    
	switch ( algorithm )
	{
		case kCCAlgorithmAES128:
		{
			if ( keyLength < 16 )
			{
				[dKey setLength: 16];
			}
			else if ( keyLength < 24 )
			{
				[dKey setLength: 24];
			}
			else
			{
				[dKey setLength: 32];
			}
			
			break;
		}
			
		case kCCAlgorithmDES:
		{
			[dKey setLength: 8];
			break;
		}
			
		case kCCAlgorithm3DES:
		{
			[dKey setLength: 24];
			break;
		}
			
		case kCCAlgorithmCAST:
		{
			if ( keyLength < 5 )
			{
				[dKey setLength: 5];
			}
			else if ( keyLength > 16 )
			{
				[dKey setLength: 16];
			}
			
			break;
		}
			
		case kCCAlgorithmRC4:
		{
			if ( keyLength > 512 )
				[dKey setLength: 512];
			break;
		}
			
		default:
			break;
	}
    
    return dKey;
    
}

-(NSData *) CCCryptorEncryptedUsingAlgorithm: (CCAlgorithm) algorithm key:(id) key{
    
    CCCryptorRef cryptor = NULL;
	CCCryptorStatus status = kCCSuccess;
    
    NSData * md = NSDataCCCryptorKey(algorithm,key);
    
    status = CCCryptorCreate( kCCEncrypt, algorithm, kCCOptionPKCS7Padding | kCCOptionECBMode,
                             [md bytes], [md length], NULL,
                             &cryptor );
	
	if ( status != kCCSuccess ){
		return nil;
	}

    size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
	void * buf = malloc( bufsize );
	size_t bufused = 0;
    size_t bytesTotal = 0;
    
	status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused );
	if ( status != kCCSuccess )
	{
		free( buf );
		return nil ;
	}
    
    bytesTotal += bufused;
	
	status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
	if ( status != kCCSuccess )
	{
		free( buf );
		return nil ;
	}
    
    bytesTotal += bufused;
	
	return [NSData dataWithBytesNoCopy: buf length: bytesTotal];

}

-(NSData *) CCCryptorDecryptedUsingAlgorithm: (CCAlgorithm) algorithm key:(id) key{
    
    CCCryptorRef cryptor = NULL;
	CCCryptorStatus status = kCCSuccess;
    
    NSData * md = NSDataCCCryptorKey(algorithm,key);
    
    status = CCCryptorCreate( kCCDecrypt, algorithm, kCCOptionPKCS7Padding | kCCOptionECBMode,
                             [md bytes], [md length], NULL,
                             &cryptor );
	
	if ( status != kCCSuccess ){
		return nil;
	}
    
    size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
	void * buf = malloc( bufsize );
	size_t bufused = 0;
    size_t bytesTotal = 0;
    
	status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                             buf, bufsize, &bufused );
	if ( status != kCCSuccess )
	{
		free( buf );
		return nil ;
	}
    
    bytesTotal += bufused;
	
	status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
	if ( status != kCCSuccess )
	{
		free( buf );
		return nil ;
	}
    
    bytesTotal += bufused;
	
	return [NSData dataWithBytesNoCopy: buf length: bytesTotal];

}

@end
