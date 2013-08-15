//
//  VTDOMStyleSheet.h
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <vTeam/VTDOMStyle.h>

@interface VTDOMStyleSheet : NSObject

@property(nonatomic,assign) NSInteger version;

@property(nonatomic,readonly) NSArray * styles;

-(void) addStyle:(VTDOMStyle *) style;

-(void) removeStyle:(VTDOMStyle *) style;

-(void) removeAllStyles;

-(VTDOMStyle *) selectorStyleName:(NSString *) styleName;

@end
