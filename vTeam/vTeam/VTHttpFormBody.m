//
//  VTHttpFormData.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTHttpFormBody.h"

#import "NSURL+QueryValue.h"

#define HTTP_MULTIPART_TOKEN            "8jej23fkdxxd"
#define HTTP_MULTIPART_TOKEN_SIZE       12
#define HTTP_MULTIPART_TOKEN_BEGIN      "--8jej23fkdxxd"
#define HTTP_MULTIPART_TOKEN_BEGIN_SIZE (HTTP_MULTIPART_TOKEN_SIZE + 2)
#define HTTP_MULTIPART_TOKEN_END        "--8jej23fkdxxd--"
#define HTTP_MULTIPART_TOKEN_END_SIZE   (HTTP_MULTIPART_TOKEN_SIZE + 4)
#define HTTP_MULTIPART_CONTENT_TYPE     @"multipart/form-data; boundary=8jej23fkdxxd"

@implementation VTHttpFormItem

@synthesize key = _key;

-(void) dealloc{
    [_key release];
    [super dealloc];
}

@end

@implementation VTHttpFormItemValue

@synthesize value = _value;

-(void) dealloc{
    [_value release];
    [super dealloc];
}

@end

@implementation VTHttpFormItemBytes

@synthesize bytesData = _bytesData;
@synthesize filename = _filename;
@synthesize contentType = _contentType;

-(void) dealloc{
    [_contentType release];
    [_bytesData release];
    [_filename release];
    [super dealloc];
}

@end

@interface VTHttpFormBody(){
    NSMutableArray * _formItems;
}

@end

@implementation VTHttpFormBody

@synthesize contentType = _contentType;
@synthesize formItems = _formItems;

-(void) dealloc{
    [_contentType release];
    [_formItems release];
    [super dealloc];
}

-(void) addFormItem:(VTHttpFormItem *) item{
    if(_formItems == nil){
        _formItems = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_formItems addObject:item];
}

-(void) setFormItem:(VTHttpFormItem *) item{
    if(_formItems == nil){
        _formItems = [[NSMutableArray alloc] initWithCapacity:4];
    }
    else{
        NSInteger c = [_formItems count];
        NSInteger i = 0;
        
        while(i <c){
            VTHttpFormItem * ii = [_formItems objectAtIndex:i];
            
            if([ii.key isEqualToString:item.key]){
                
                [_formItems removeObjectAtIndex:i];
                c --;
                continue;
            }
            
            i ++;
            
        }
    }
    [_formItems addObject:item];
}

-(void) addItemValue:(NSString *) value forKey:(NSString *) key{
    VTHttpFormItemValue * item = [[VTHttpFormItemValue alloc] init];
    item.key = key;
    item.value = value;
    [self addFormItem:item];
    [item release];
}

-(void) setItemValue:(NSString *) value forKey:(NSString *) key{
    VTHttpFormItemValue * item = [[VTHttpFormItemValue alloc] init];
    item.key = key;
    item.value = value;
    [self setFormItem:item];
    [item release];
}

-(void) addItemBytes:(NSData *) bytesData contentType:(NSString *) contentType forKey:(NSString *) key{
    VTHttpFormItemBytes * item = [[VTHttpFormItemBytes alloc] init];
    item.key = key;
    item.contentType = contentType;
    item.bytesData = bytesData;
    [self addFormItem:item];
    [item release];
}

-(void) setItemBytes:(NSData *) bytesData contentType:(NSString *) contentType forKey:(NSString *) key{
    VTHttpFormItemBytes * item = [[VTHttpFormItemBytes alloc] init];
    item.key = key;
    item.contentType = contentType;
    item.bytesData = bytesData;
    [self setFormItem:item];
    [item release];
}

-(void) addItemBytes:(NSData *) bytesData contentType:(NSString *) contentType filename:(NSString *) filename forKey:(NSString *) key{
    VTHttpFormItemBytes * item = [[VTHttpFormItemBytes alloc] init];
    item.key = key;
    item.contentType = contentType;
    item.bytesData = bytesData;
    item.filename = filename;
    [self addFormItem:item];
    [item release];
}

-(void) setItemBytes:(NSData *) bytesData contentType:(NSString *) contentType filename:(NSString *) filename forKey:(NSString *) key{
    VTHttpFormItemBytes * item = [[VTHttpFormItemBytes alloc] init];
    item.key = key;
    item.contentType = contentType;
    item.bytesData = bytesData;
    item.filename = filename;
    [self setFormItem:item];
    [item release];
}

-(NSString *) contentType{
    return _contentType;
}

-(NSData *) bytesBody{
    
    NSMutableData * md = [NSMutableData data];
    
    BOOL hasBytesContent = NO;
    
    for(id item in _formItems){
        if([item isKindOfClass:[VTHttpFormItemBytes class]]){
            hasBytesContent = YES;
            break;
        }
    }
    
    if(hasBytesContent){
        
        self.contentType = HTTP_MULTIPART_CONTENT_TYPE;
        
        for(id item in _formItems){
            if([item isKindOfClass:[VTHttpFormItemBytes class]]){
                
                [md appendBytes:(void *)HTTP_MULTIPART_TOKEN_BEGIN length:HTTP_MULTIPART_TOKEN_BEGIN_SIZE];
                [md appendBytes:(void *)"\r\n" length:2];
                [md appendBytes:(void *)"Content-Disposition: form-data; name=\"" length:38];
                [md appendData:[[item key] dataUsingEncoding:NSUTF8StringEncoding]];
                [md appendBytes:(void *)"\"; filename=\"" length:13];
                if([item filename]){
                    [md appendData:[[item filename] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                else{
                    [md appendData:[[item key] dataUsingEncoding:NSUTF8StringEncoding]];
                }
                [md appendBytes:(void *)"\"\r\n" length:3];
                
                [md appendBytes:(void *)"Content-Type: " length:14];
                [md appendData:[[item contentType] dataUsingEncoding:NSUTF8StringEncoding]];
                [md appendBytes:(void *)"\r\n" length:2];
                
                [md appendBytes:(void *)"Content-Transfer-Encoding: binary\r\n\r\n" length:37];
                
                [md appendData:[item bytesData]];
                
                [md appendBytes:(void *)"\r\n" length:2];
                
            }
            else if([item isKindOfClass:[VTHttpFormItemValue class]]) {
                
                [md appendBytes:(void *)HTTP_MULTIPART_TOKEN_BEGIN length:HTTP_MULTIPART_TOKEN_BEGIN_SIZE];
                [md appendBytes:(void *)"\r\n" length:2];
                [md appendBytes:(void *)"Content-Disposition: form-data; name=\"" length:38];
                [md appendData:[[item key] dataUsingEncoding:NSUTF8StringEncoding]];
                [md appendBytes:(void *)"\"\r\n\r\n" length:5];
                
                [md appendData:[[(VTHttpFormItemValue *) item value] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [md appendBytes:(void *)"\r\n" length:2];
            }
        }
        
        [md appendBytes:(void *)HTTP_MULTIPART_TOKEN_END length:HTTP_MULTIPART_TOKEN_END_SIZE];
    
    }
    else{
        self.contentType = @"application/x-www-form-urlencoded";
        
        for(id item in _formItems){
            
            if([item isKindOfClass:[VTHttpFormItemValue class]]) {
                
                [md appendBytes:(void *)"&" length:1];
                [md appendData:[[item key] dataUsingEncoding:NSUTF8StringEncoding]];
                [md appendBytes:(void *)"=" length:1];
                [md appendData:[[NSURL encodeQueryValue:[(VTHttpFormItemValue *) item value]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }

    }
    
    return md;
}

@end
