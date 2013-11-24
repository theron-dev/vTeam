//
//  VTDOMElement+Layout.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"

@implementation VTDOMElement (Layout)

-(CGSize) contentSize{
    return [[self valueForKey:@"contentSize"] CGSizeValue];
}

-(void) setContentSize:(CGSize)contentSize{
    [self setValue:[NSValue valueWithCGSize:contentSize] forKey:@"contentSize"];
}

-(UIEdgeInsets) padding{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;

    NSString * padding = [self stringValueForKey:@"padding"];
    NSString * paddingLeft = [self stringValueForKey:@"padding-left"];
    NSString * paddingTop = [self stringValueForKey:@"padding-top"];
    NSString * paddingRight = [self stringValueForKey:@"padding-right"];
    NSString * paddingBottom = [self stringValueForKey:@"padding-bottom"];
    
    CGFloat value = [padding floatValue];
    
    insets.left = paddingLeft == nil ? value : [paddingLeft floatValue];
    insets.top = paddingTop == nil ? value : [paddingTop floatValue];
    insets.right = paddingRight == nil ? value : [paddingRight floatValue];
    insets.bottom = paddingBottom == nil ? value : [paddingBottom floatValue];
    
    return insets;
}

-(UIEdgeInsets) margin{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    NSString * margin = [self stringValueForKey:@"margin"];
    NSString * marginLeft = [self stringValueForKey:@"margin-left"];
    NSString * marginTop = [self stringValueForKey:@"margin-top"];
    NSString * marginRight = [self stringValueForKey:@"margin-right"];
    NSString * marginBottom = [self stringValueForKey:@"margin-bottom"];
    
    CGFloat value = [margin floatValue];
    
    insets.left = marginLeft == nil ? value : [marginLeft floatValue];
    insets.top = marginTop == nil ? value : [marginTop floatValue];
    insets.right = marginRight == nil ? value : [marginRight floatValue];
    insets.bottom = marginBottom == nil ? value : [marginBottom floatValue];
    
    return insets;
}

-(CGSize) layoutChildren:(UIEdgeInsets) padding{
    
    CGRect frame = [self frame];
    CGSize size = CGSizeZero;
    CGSize insetSize = CGSizeMake(frame.size.width - padding.left - padding.right
                                  , frame.size.height - padding.top - padding.bottom);
    
    NSString * layout = [self stringValueForKey:@"layout"];
    
    if([layout isEqualToString:@"flow"]){
        
        CGPoint p = CGPointMake(padding.left, padding.top);
        CGFloat lineHeight = 0;
        CGFloat width = padding.left + padding.right;
        
        for(VTDOMElement * element in [self childs]){
            
            [element layout:insetSize];
            
            CGRect r = [element frame];
            UIEdgeInsets margin = [element margin];
            
            if(p.x + r.size.width + margin.left + margin.right <= frame.size.width - padding.right){
                
                r.origin = CGPointMake(p.x + margin.left, p.y + margin.top);
                p.x += r.size.width + margin.left + margin.right;
                
                if(lineHeight < r.size.height + margin.top + margin.bottom){
                    lineHeight = r.size.height + margin.top + margin.bottom;
                }
                if(width < p.x + padding.right){
                    width = p.x + padding.right;
                }
            }
            else {
                p.x = padding.left;
                p.y += lineHeight;
                lineHeight = r.size.height + margin.top + margin.bottom;
                r.origin = CGPointMake(p.x + margin.left, p.y + margin.top);
                p.x += r.size.width + margin.left + margin.right;
                if(width < p.x + padding.right){
                    width = p.x + padding.right;
                }
            }
        
            [element setFrame:r];
        }
        
        size = CGSizeMake(width, p.y + lineHeight + padding.bottom);
        
    }
    else{
        
        for(VTDOMElement * element in [self childs]){
            
            [element layout:insetSize];
            
            CGRect r = [element frame];
            
            NSString * left = [element stringValueForKey:@"left"];
            NSString * right = [element stringValueForKey:@"right"];
            NSString * top = [element stringValueForKey:@"top"];
            NSString * bottom = [element stringValueForKey:@"bottom"];
            
            if([left isEqualToString:@"auto"]){
                if([right isEqualToString:@"auto"]){
                    r.origin.x = (frame.size.width - r.size.width) / 2.0;
                }
                else{
                    r.origin.x = (frame.size.width - r.size.width - padding.right - [right floatValue]);
                }
            }
            else{
                r.origin.x = padding.left + [left floatValue];
            }
            
            if([top isEqualToString:@"auto"]){
                if([bottom isEqualToString:@"auto"]){
                    r.origin.y = (frame.size.height - r.size.height) / 2.0;
                }
                else{
                    r.origin.y = frame.size.height - r.size.height - padding.bottom - [bottom floatValue];
                }
            }
            else{
                r.origin.y = padding.top + [top floatValue];
            }
            
            [element setFrame:r];
            
            if(r.origin.x + r.size.width + padding.right > size.width){
                size.width = r.origin.x +r.size.width +padding.right;
            }
            
            if(r.origin.y + r.size.height + padding.bottom > size.height){
                size.height = r.origin.y +r.size.height +padding.bottom;
            }
        }
    }
    
    [self setContentSize:size];
    
    return size;
}

-(CGSize) layout:(CGSize) size{

    UIEdgeInsets insets = [self padding];
    
    CGRect frame = CGRectZero;
    
    NSString * width = [self stringValueForKey:@"width"];
    NSString * height = [self stringValueForKey:@"height"];
    
    if([width isEqualToString:@"auto"]){
        frame.size.width = MAXFLOAT;
    }
    else if([width hasSuffix:@"%"]){
        frame.size.width = [width floatValue] * size.width / 100.0;
    }
    else{
        frame.size.width = [width floatValue];
    }
    
    if([height isEqualToString:@"auto"]){
        frame.size.height = MAXFLOAT;
    }
    else if([height hasSuffix:@"%"]){
        frame.size.height = [height floatValue] * size.height / 100.0;
    }
    else{
        frame.size.height = [height floatValue];
    }
    
    [self setFrame:frame];
    
    if(frame.size.width == MAXFLOAT || frame.size.height == MAXFLOAT){
        
        CGSize contentSize = [self layoutChildren:insets];
        
        if(frame.size.width == MAXFLOAT){
            frame.size.width = contentSize.width;
            NSString * max = [self stringValueForKey:@"max-width"];
            NSString * min = [self stringValueForKey:@"min-width"];
            if(max && frame.size.width > [max floatValue]){
                frame.size.width = [max floatValue];
            }
            if(min && frame.size.width < [min floatValue]){
                frame.size.width = [min floatValue];
            }
        }
        
        if(frame.size.height == MAXFLOAT){
            frame.size.height = contentSize.height;
            NSString * max = [self stringValueForKey:@"max-height"];
            NSString * min = [self stringValueForKey:@"min-height"];
            if(max && frame.size.height > [max floatValue]){
                frame.size.height = [max floatValue];
            }
            if(min && frame.size.height < [min floatValue]){
                frame.size.height = [min floatValue];
            }
        }
        
        [self setFrame:frame];
        
        return contentSize;
    }
    else{
        return [self layoutChildren:insets];
    }
    
}

-(CGSize) layout{
    return [self layoutChildren:self.padding];
}

@end
