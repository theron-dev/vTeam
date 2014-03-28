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

typedef  NSString * (^ VTDataOutletStringValue) (id data,NSString * keyPath);

@interface NSString (VTDataOutlet)

-(NSString *) stringByDataOutlet:(id) data;

-(NSString *) stringByDataOutlet:(id) data stringValue: (VTDataOutletStringValue)value;

@end


@interface VTDataOutlet : NSObject

@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) IBOutlet id view;
@property(nonatomic,retain) IBOutletCollection(NSObject) NSArray * views;

@property(nonatomic,retain) NSString * keyPath;
@property(nonatomic,retain) NSString * stringKeyPath;
@property(nonatomic,retain) NSString * stringFormat;
@property(nonatomic,retain) NSString * stringHtmlFormat;
@property(nonatomic,retain) NSString * booleanKeyPath;
@property(nonatomic,retain) NSString * valueKeyPath;
@property(nonatomic,retain) NSString * enabledKeyPath;
@property(nonatomic,retain) NSString * disabledKeyPath;
@property(nonatomic,retain) id value;

-(void) applyDataOutlet:(id) data;

@end