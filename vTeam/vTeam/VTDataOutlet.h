//
//  VTDataOutlet.h
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject(VTDataOutlet)

-(id) dataForKey:(NSString *) key;

-(id) dataForKeyPath:(NSString *) keyPath;

@end

@interface NSString (VTDataOutlet)

-(NSString *) stringByDataOutlet:(id) data;

@end


@interface VTDataOutlet : NSObject

@property(nonatomic,retain) IBOutlet id view;
@property(nonatomic,retain) NSString * keyPath;
@property(nonatomic,retain) NSString * stringKeyPath;
@property(nonatomic,retain) NSString * stringFormat;
@property(nonatomic,retain) NSString * booleanKeyPath;

-(void) applyDataOutlet:(id) data;

@end