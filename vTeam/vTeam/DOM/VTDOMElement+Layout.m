//
//  VTDOMElement+Layout.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Style.h"
#import "VTDOMBRElement.h"

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
        CGFloat maxWidth = frame.size.width;
        
        if(maxWidth == MAXFLOAT){
            NSString * max = [self attributeValueForKey:@"max-width"];
            if(max){
                maxWidth = [max floatValue];
            }
        }
        
        for(VTDOMElement * element in [self childs]){
            
            UIEdgeInsets margin = [element margin];
            
            [element layout:CGSizeMake(insetSize.width - margin.left - margin.right
                                       , insetSize.height - margin.top - margin.bottom)];
            
            CGRect r = [element frame];
  
            if(![element isKindOfClass:[VTDOMBRElement class]]
                &&  ( p.x + r.size.width + margin.left + margin.right <= maxWidth - padding.right)){
                
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
            
            float left = [element floatValueForKey:@"left" of:insetSize.width defaultValue:0];
            float right = [element floatValueForKey:@"right" of:insetSize.width defaultValue:0];
            float top = [element floatValueForKey:@"top" of:insetSize.height defaultValue:0];
            float bottom = [element floatValueForKey:@"bottom" of:insetSize.height defaultValue:0];
            
            if(left == MAXFLOAT){
                if(right == MAXFLOAT){
                    r.origin.x = (frame.size.width - r.size.width) / 2.0;
                }
                else {
                    r.origin.x = (frame.size.width - r.size.width - padding.right - right);
                }
            }
            else {
                r.origin.x = left + padding.left;
            }
            
            if(top == MAXFLOAT){
                if(bottom == MAXFLOAT){
                    r.origin.y = (frame.size.height - r.size.height) / 2.0;
                }
                else {
                    r.origin.y = (frame.size.height - r.size.height - padding.bottom - bottom);
                }
            }
            else {
                r.origin.y = top + padding.top;
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
    
    frame.size.width = [self floatValueForKey:@"width" of:size.width defaultValue:0];
    frame.size.height = [self floatValueForKey:@"height" of:size.height defaultValue:0];
    
    [self setFrame:frame];
    
    if(frame.size.width == MAXFLOAT || frame.size.height == MAXFLOAT){
        
        CGSize contentSize = [self layoutChildren:insets];
        
        if(frame.size.width == MAXFLOAT){
            frame.size.width = contentSize.width;
            float v = [self floatValueForKey:@"max-width" of:size.width defaultValue:frame.size.width];
            if(frame.size.width > v){
                frame.size.width = v;
            }
            v = [self floatValueForKey:@"min-width" of:size.width defaultValue:frame.size.width];
            if(frame.size.width < v){
                frame.size.width = v;
            }
        }
        
        if(frame.size.height == MAXFLOAT){
            frame.size.height = contentSize.height;
            float v = [self floatValueForKey:@"max-height" of:size.height defaultValue:frame.size.height];
            if(frame.size.height > v){
                frame.size.height = v;
            }
            v = [self floatValueForKey:@"min-height" of:size.height defaultValue:frame.size.height];
            if(frame.size.height < v){
                frame.size.height = v;
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
