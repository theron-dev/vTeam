//
//  VTChartDataReader.h
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTChartDataReader : NSObject

@property(nonatomic,retain) NSString * dataKeyPath;
@property(nonatomic,retain) id defaultValue;

-(double) doubleValue:(id) dataItem;

-(int) intValue:(id) dataItem;

-(float) floatValue:(id) dataItem;

-(NSString *) stringValue:(id) dataItem;

-(NSDictionary *) dictionaryValue:(id) dataItem;

-(NSArray *) arrayValue:(id) dataItem;

-(id) objectValue:(id) dataItem;

-(NSArray *) dataItemsValue:(id) dataSource;

-(UIColor *) colorValue:(id) dataItem;

-(id) initWithDataKeyPath:(NSString *) dataKeyPath;

-(id) initWithDataKeyPath:(NSString *) dataKeyPath defaultValue:(id)defaultValue;

@end
