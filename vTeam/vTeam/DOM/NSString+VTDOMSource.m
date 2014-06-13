//
//  NSString+VTDOMSource.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "NSString+VTDOMSource.h"

@implementation NSString (VTDOMSource)

-(NSString *) htmlEncodeString{
    NSString * v = self;
    v = [v stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    v = [v stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    v = [v stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    v = [v stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    v = [v stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    v = [v stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    v = [v stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    v = [v stringByReplacingOccurrencesOfString:@"\"" withString:@"&qout;"];
    return v;
}

-(NSString *) htmlDecodeString{
    NSString * v = self;
    v = [v stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    v = [v stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    v = [v stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    v = [v stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    v = [v stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    v = [v stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    v = [v stringByReplacingOccurrencesOfString:@"&qout;" withString:@"\""];
    return v;
}

-(NSString *) htmlStringByDOMSource:(id)data{
    return [self htmlStringByDOMSource:data htmlEncoded:YES];
}

-(NSString *) htmlStringByDOMSource:(id) data htmlEncoded:(BOOL) htmlEncoded{
    
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
                    [ms appendFormat:@"%C",uc];
                }
            }
                break;
            case 1:
            {
                if(uc == '}'){
                    
                    if([keyPath hasPrefix:@"$"]){
                        id v = [data dataForKeyPath:[keyPath substringFromIndex:1]];
                        if(v){
                            if([v isKindOfClass:[NSString class]]){
                                [ms appendString:v];
                            }
                            else{
                                [ms appendFormat:@"%@",v];
                            }
                        }
                    }
                    else{
                        id v = [data dataForKeyPath:keyPath];
                        if(v){
                            if([v isKindOfClass:[NSString class]]){
                                [ms appendString:htmlEncoded ? [v htmlEncodeString] : v];
                            }
                            else{
                                [ms appendFormat:@"%@",v];
                            }
                        }

                    }
                    s = 0;
                }
                else{
                    [keyPath appendFormat:@"%C",uc];
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
