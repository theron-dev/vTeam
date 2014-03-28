//
//  VTHttpFormData.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VTHttpFormItem : NSObject

@property(nonatomic,retain) NSString * key;

@end

@interface VTHttpFormItemValue : VTHttpFormItem

@property(nonatomic,retain) NSString * value;

@end

@interface VTHttpFormItemBytes : VTHttpFormItem

@property(nonatomic,retain) NSString * contentType;
@property(nonatomic,retain) NSData * bytesData;
@property(nonatomic,retain) NSString * filename;

@end

@interface VTHttpFormBody : NSObject


@property(nonatomic,readonly) NSArray * formItems;

@property(nonatomic,retain) NSString * contentType;

-(void) addItemValue:(NSString *) value forKey:(NSString *) key;

-(void) setItemValue:(NSString *) value forKey:(NSString *) key;

-(void) addItemBytes:(NSData *) bytesData contentType:(NSString *) contentType forKey:(NSString *) key;

-(void) setItemBytes:(NSData *) bytesData contentType:(NSString *) contentType forKey:(NSString *) key;

-(void) addItemBytes:(NSData *) bytesData contentType:(NSString *) contentType filename:(NSString *) filename forKey:(NSString *) key;

-(void) setItemBytes:(NSData *) bytesData contentType:(NSString *) contentType filename:(NSString *) filename forKey:(NSString *) key;

-(NSData *) bytesBody;

@end
