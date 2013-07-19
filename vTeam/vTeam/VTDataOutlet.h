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

@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutlet id view;
@property(nonatomic,retain) NSString * keyPath;
@property(nonatomic,retain) NSString * stringKeyPath;
@property(nonatomic,retain) NSString * stringFormat;
@property(nonatomic,retain) NSString * booleanKeyPath;
@property(nonatomic,retain) NSString * valueKeyPath;
@property(nonatomic,retain) NSString * enabledKeyPath;
@property(nonatomic,retain) NSString * disabledKeyPath;
@property(nonatomic,retain) id value;

-(void) applyDataOutlet:(id) data;

@end