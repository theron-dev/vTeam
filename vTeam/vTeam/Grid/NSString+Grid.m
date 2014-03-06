//
//  NSString+Grid.m
//  vTeam
//
//  Created by zhang hailong on 13-11-11.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+Grid.h"

@implementation NSString (Grid)


-(NSString *) expressionOfKeyPath:(NSString *) keyPath data:(id) data{
    
    id value = nil;
    
    if([keyPath hasPrefix:@"percentage:"]){
        value = [data valueForKeyPath:[keyPath substringFromIndex:11]];
        if(value){
            value = [NSString stringWithFormat:@"%.1lf%%",[value doubleValue] * 100 ];
        }
    }
    else{
        value = [data valueForKeyPath:keyPath];
    }
    
    if(value){
        return [NSString stringWithFormat:@"%@",value];
    }
    return nil;
}

-(NSString *) expressionOfData:(id) data{
    
    NSMutableString * ms = [NSMutableString stringWithCapacity:30];
    NSMutableString * keyPath = [NSMutableString stringWithCapacity:30];
    
    unichar uc;
    
    NSUInteger length = [self length];
    int s = 0;
    
    for(int i=0;i<length;i++){
        
        uc = [self characterAtIndex:i];
        
        switch (s) {
            case 0:
            {
                if(uc == '{'){
                    NSRange r = {0,[keyPath length]};
                    [keyPath deleteCharactersInRange:r];
                    s =1;
                }
                else{
                    [ms appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            case 1:
            {
                if(uc == '}'){
                    id v = [self expressionOfKeyPath:keyPath data:data];
                    if(v){
                        [ms appendFormat:@"%@",v];
                    }
                    s = 0;
                }
                else{
                    [keyPath appendString:[NSString stringWithCharacters:&uc length:1]];
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return ms;
}

@end
