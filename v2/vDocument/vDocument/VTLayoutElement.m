//
//  VTLayoutElement.m
//  vDocument
//
//  Created by zhang hailong on 14-7-2.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTLayoutElement.h"

#import "VTElement+Value.h"

#import "IVTLayoutElement.h"

#import "VTBRElement.h"

@implementation VTLayoutElement

@synthesize frame = _frame;
@synthesize contentSize = _contentSize;
@synthesize layouted = _layouted;

-(void) setFrame:(CGRect)frame{
    _frame = frame;
    _layouted = YES;
}

-(CGSize) layoutChildren:(UIEdgeInsets) padding{
    
    CGSize size = CGSizeZero;
    CGSize insetSize = CGSizeMake(_frame.size.width - padding.left - padding.right, _frame.size.height - padding.top - padding.bottom);
    
    NSString * layout = [self stringValueForKey:@"layout"];
    
    if([layout isEqualToString:@"flow"]){
        
        CGPoint p = CGPointMake(padding.left, padding.top);
        CGFloat lineHeight = 0;
        CGFloat width = padding.left + padding.right;
        CGFloat maxWidth = _frame.size.width;
        
        if(maxWidth == MAXFLOAT){
            maxWidth = [self floatValueForKey:@"max-width" defaultValue:maxWidth];
        }
        
        for (VTElement * element in [self childs]) {
            
            if([element conformsToProtocol:@protocol(IVTLayoutElement)]){
                
                id<IVTLayoutElement> layoutElement = (id<IVTLayoutElement>) element;
                
                UIEdgeInsets margin = [layoutElement margin];
                
                [layoutElement layout:CGSizeMake(insetSize.width - margin.left - margin.right, insetSize.height - margin.top - margin.bottom)];
                
                CGRect r = [layoutElement frame];
                
                if(( p.x + r.size.width + margin.left + margin.right <= maxWidth - padding.right)){
                    
                    r.origin.x = p.x + margin.left;
                    r.origin.y = p.y + margin.top;
                    
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
                    r.origin.x = p.x + margin.left;
                    r.origin.y = p.y + margin.top;
                    p.x += r.size.width + margin.left + margin.right;
                    if(width < p.x + padding.right){
                        width = p.x + padding.right;
                    }
                }
            }
            else if([element isKindOfClass:[VTBRElement class]]){
                p.x = padding.left;
                p.y += lineHeight;
                lineHeight = 0;
            }
            
        }
        
        size.width = width;
        size.height = p.y + lineHeight + padding.bottom;
    }
    else {
        
        size.width = padding.left + padding.right;
        size.height = padding.top + padding.bottom;
        
        for (VTElement * element in [self childs]) {
            
            if([element conformsToProtocol:@protocol(IVTLayoutElement)]){
                
                id<IVTLayoutElement> layoutElement = (id<IVTLayoutElement>) element;
                
                [layoutElement layout:CGSizeMake(insetSize.width, insetSize.height)];
                
                CGRect r = [layoutElement frame];
                
                CGFloat left = [element floatValueForKey:@"left" of:insetSize.width defaultValue:0];
                
                CGFloat right = [element floatValueForKey:@"right" of:insetSize.width defaultValue:MAXFLOAT];
                
                CGFloat top = [element floatValueForKey:@"top" of:insetSize.height defaultValue:0];
                
                CGFloat bottom = [element floatValueForKey:@"bottom" of:insetSize.height defaultValue:MAXFLOAT];
                
                if(left == MAXFLOAT){
                    if(right == MAXFLOAT){
                        r.origin.x = padding.left + (insetSize.width - r.size.width) * 0.5;
                    }
                    else{
                        r.origin.x = padding.left + (insetSize.width - r.size.width - right);
                    }
                }
                else {
                    r.origin.x = padding.left + left;
                }
               
                if(top == MAXFLOAT){
                    if(bottom == MAXFLOAT){
                        r.origin.y = padding.top + (insetSize.height - r.size.height) * 0.5;
                    }
                    else {
                        r.origin.y = padding.top + (insetSize.height - r.size.height - bottom);
                    }
                }
                else {
                    r.origin.y = padding.top + top;
                }
                
                if(r.origin.x + r.size.width + padding.right > size.width){
                    size.width = r.origin.x + r.size.width + padding.right;
                }
                
                if(r.origin.y + r.size.height + padding.bottom > size.height ){
                    size.height = r.origin.y + r.size.height +padding.bottom;
                }
                
            }
            
        }
    }
    
    [self setContentSize:size];
    
    return size;
}

-(CGSize) layout:(CGSize) size{
    
    [self setFrame:CGRectMake(0, 0
                              , [self floatValueForKey:@"width" of:size.width defaultValue:0]
                              , [self floatValueForKey:@"height" of:size.height defaultValue:0])];

    UIEdgeInsets padding = [self padding];
    
    
    if(_frame.size.width == MAXFLOAT || _frame.size.height == MAXFLOAT){
        
        CGSize contentSize = [self layoutChildren:padding];
        
        if(_frame.size.width == MAXFLOAT){
            
            _frame.size.width = contentSize.width;
            
            CGFloat max = [self floatValueForKey:@"max-width" of:size.width defaultValue:_frame.size.width];
            CGFloat min = [self floatValueForKey:@"min-width" of:size.width defaultValue:_frame.size.width];
            
            if(_frame.size.width > max){
                _frame.size.width = max;
            }
            if(_frame.size.width < min){
                _frame.size.width = min;
            }
        }
        
        if(_frame.size.height == MAXFLOAT){
            
            _frame.size.height = contentSize.width;
            
            CGFloat max = [self floatValueForKey:@"max-height" of:size.height defaultValue:_frame.size.height];
            CGFloat min = [self floatValueForKey:@"min-height" of:size.height defaultValue:_frame.size.height];
            
            if(_frame.size.height > max){
                _frame.size.height = max;
            }
            if(_frame.size.height < min){
                _frame.size.height = min;
            }
        }
        
        return contentSize;
        
    }
    else {
        return [self layoutChildren:padding];
    }

}

-(CGSize) layout{
    return [self layoutChildren:self.padding];
}

-(UIEdgeInsets) padding{
    
    CGFloat v = [self floatValueForKey:@"padding" of:_frame.size.width defaultValue:0];
    
    return UIEdgeInsetsMake(
                            [self floatValueForKey:@"padding-top" of:_frame.size.height defaultValue:v]
                            , [self floatValueForKey:@"padding-left" of:_frame.size.width defaultValue:v]
                            , [self floatValueForKey:@"padding-bottom" of:_frame.size.height defaultValue:v]
                            , [self floatValueForKey:@"padding-right" of:_frame.size.width defaultValue:v]);
    
}

-(UIEdgeInsets) margin{
    
    CGFloat v = [self floatValueForKey:@"margin" of:_frame.size.width defaultValue:0];
    
    return UIEdgeInsetsMake(
                            [self floatValueForKey:@"margin-top" of:_frame.size.height defaultValue:v]
                            , [self floatValueForKey:@"margin-left" of:_frame.size.width defaultValue:v]
                            , [self floatValueForKey:@"margin-bottom" of:_frame.size.height defaultValue:v]
                            , [self floatValueForKey:@"margin-right" of:_frame.size.width defaultValue:v]);
    
}

@end
