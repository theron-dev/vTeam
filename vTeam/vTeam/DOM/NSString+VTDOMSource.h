//
//  NSString+VTDOMSource.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/vTeam.h>

@interface NSString (VTDOMSource)

-(NSString *) htmlEncodeString;

-(NSString *) htmlDecodeString;

-(NSString *) htmlStringByDOMSource:(id) data;

-(NSString *) htmlStringByDOMSource:(id) data htmlEncoded:(BOOL) htmlEncoded;

@end
