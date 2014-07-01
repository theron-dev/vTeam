//
//  VTElementParser.h
//  vElement
//
//  Created by zhang hailong on 14-6-30.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vElement/VTElement.h>

@interface VTElementParser : NSObject

-(BOOL) parseXML:(NSString *) xmlContent url:(NSURL *) url toElement:(VTElement *) element atIndex:(NSUInteger) index;

@end
