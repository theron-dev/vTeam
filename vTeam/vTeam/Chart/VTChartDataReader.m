//
//  VTChartDataReader.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartDataReader.h"

#import "NSObject+VTValue.h"

@implementation VTChartDataReader

@synthesize dataKeyPath = _dataKeyPath;
@synthesize defaultValue = _defaultValue;

-(id) initWithDataKeyPath:(NSString *) dataKeyPath{
    if((self = [super init])){
        self.dataKeyPath = dataKeyPath;
    }
    return self;
}

-(id) initWithDataKeyPath:(NSString *) dataKeyPath defaultValue:(id)defaultValue{
    if((self = [super init])){
        self.dataKeyPath = dataKeyPath;
        self.defaultValue = defaultValue;
    }
    return self;
}

-(void) dealloc{
    [_dataKeyPath release];
    [_defaultValue release];
    [super dealloc];
}

-(double) doubleValue:(id) dataSource{
    return [dataSource doubleValueForKeyPath:_dataKeyPath defaultValue:[_defaultValue doubleValue]];
}

-(int) intValue:(id) dataSource{
    return [dataSource intValueForKeyPath:_dataKeyPath defaultValue:[_defaultValue intValue]];
}

-(float) floatValue:(id) dataSource{
    return [dataSource floatValueForKeyPath:_dataKeyPath defaultValue:[_defaultValue floatValue]];
}

-(NSString *) stringValue:(id) dataSource{
    return [dataSource stringValueForKeyPath:_dataKeyPath defaultValue:_defaultValue];
}

-(NSDictionary *) dictionaryValue:(id) dataSource{
    return [dataSource dictionaryValueForKeyPath:_dataKeyPath];
}

-(NSArray *) arrayValue:(id) dataSource{
    return [dataSource arrayValueForKeyPath:_dataKeyPath];
}

-(id) objectValue:(id) dataSource{
    return [dataSource objectValueForKeyPath:_dataKeyPath defaultValue:_defaultValue];
}

-(NSArray *) dataItemsValue:(id) dataSource{
    
    if(_dataKeyPath == nil){
        if([dataSource isKindOfClass:[NSArray class]]){
            return dataSource;
        }
        else if([dataSource isKindOfClass:[NSDictionary class]]){
            return [NSArray arrayWithObject:dataSource];
        }
        return nil;
    }

    return [dataSource arrayValueForKeyPath:_dataKeyPath];
}

-(UIColor *) colorValue:(id) dataItem{
    
    id v = [dataItem objectValueForKeyPath:_dataKeyPath];
    
    if(v){
        
        if([v isKindOfClass:[UIColor class]]){
            return v;
        }
        
        if([v isKindOfClass:[NSString class]]){
        
            int r=0,g=0,b=0;
            float a = 1.0;
            
            sscanf([v UTF8String], "#%02x%02x%02x %f",&r,&g,&b,&a);
            
            return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
            
        }

    }
    
    return _defaultValue;
}
@end
