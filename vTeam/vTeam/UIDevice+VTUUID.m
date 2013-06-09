//
//  UIDevice+VTUUID.m
//  vTeam
//
//  Created by zhang hailong on 13-6-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "UIDevice+VTUUID.h"

#import "NSString+VTMD5String.h"

@implementation UIDevice (VTUUID)

-(NSString * ) vtUniqueIdentifier{
    
    if([self respondsToSelector:@selector(identifierForVendor)]){
        return [[self identifierForVendor] UUIDString];
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    id vtUniqueIdentifier = [userDefaults valueForKey:@"vtUniqueIdentifier"];
    
    if(vtUniqueIdentifier == nil){
        vtUniqueIdentifier = [[[[NSUUID UUID] UUIDString] vtMD5String] stringByAppendingString:@"_VT"];
        [userDefaults setValue:vtUniqueIdentifier forKey:@"vtUniqueIdentifier"];
        [userDefaults synchronize];
    }
    
    return vtUniqueIdentifier;
}
@end
