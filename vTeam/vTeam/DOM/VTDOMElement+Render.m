//
//  VTDOMElement+Render.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMDocument.h"
#import <QuartzCore/QuartzCore.h>

@implementation VTDOMElement (Render)

-(CGFloat) cornerRadius{
    return [[self valueForKey:@"cornerRadius"] floatValue];
}

-(void) setCornerRadius:(CGFloat)cornerRadius{
    [self setValue:[NSNumber numberWithFloat:cornerRadius] forKey:@"cornerRadius"];
}

-(BOOL) isHidden{
    
    NSString * v = [self stringValueForKey:@"hidden"];
    
    if(v){
        return [VTDOMStyle booleanValue:v];
    }
    
    v = [self stringValueForKey:@"visable"];
    
    if(v){
        return ![VTDOMStyle booleanValue:v];
    }
    
    return NO;
}

-(void) render:(CGRect) rect context:(CGContextRef) context{
    
    if([self isHidden]){
        return;
    }
    
    [self draw:rect context:context];
    
    for(VTDOMElement * element in [self childs]){
        
        CGRect frame = [element frame];
        
        CGRect r = CGRectIntersection(frame, rect);
        
        if(r.size.width >0 && r.size.height >0){
            
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, r.origin.x, r.origin.y);
            
            CGFloat radius = [element floatValueForKey:@"corner-radius"];
            
            if(radius == 0.0){
                CGContextClipToRect(context, CGRectMake(0, 0, r.size.width, r.size.height) );
            }
            else{

                // 移动到初始点
                CGContextMoveToPoint(context, radius, 0);
                
                // 绘制第1条线和第1个1/4圆弧
                CGContextAddLineToPoint(context, r.size.width - radius, 0);
                CGContextAddArc(context, r.size.width - radius, radius, radius, - M_PI_2, 0.0, 0);
                
                // 绘制第2条线和第2个1/4圆弧
                CGContextAddLineToPoint(context, r.size.width, r.size.height - radius);
                CGContextAddArc(context, r.size.width - radius, r.size.height - radius, radius, 0.0, M_PI_2, 0);
                
                // 绘制第3条线和第3个1/4圆弧
                CGContextAddLineToPoint(context, radius, r.size.height);
                CGContextAddArc(context, radius, r.size.height - radius, radius, M_PI_2, M_PI, 0);
                
                // 绘制第4条线和第4个1/4圆弧
                CGContextAddLineToPoint(context, 0, radius);
                CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
                
                // 闭合路径
                CGContextClosePath(context);
                
                CGContextClip(context);
            }
            
            CGContextSaveGState(context);
            
            [element render:CGRectMake(0, 0, r.size.width, r.size.height) context:context];
            
            CGContextRestoreGState(context);
            
            CGFloat borderWidth = [element floatValueForKey:@"border-width"];
            UIColor * borderColor = [element colorValueForKey:@"border-color"];
            
            if(borderWidth && borderColor){
                
                CGContextSetLineWidth(context, borderWidth);
                CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
                
                if(radius == 0.0){
                    CGContextAddRect(context, CGRectMake(0, 0, r.size.width, r.size.height));
                    CGContextDrawPath(context, kCGPathStroke);
                }
                else{
                    
                    // 移动到初始点
                    CGContextMoveToPoint(context, radius, 0);
                    
                    // 绘制第1条线和第1个1/4圆弧
                    CGContextAddLineToPoint(context, r.size.width - radius, 0);
                    CGContextAddArc(context, r.size.width - radius, radius, radius, - M_PI_2, 0.0, 0);
                    
                    // 绘制第2条线和第2个1/4圆弧
                    CGContextAddLineToPoint(context, r.size.width, r.size.height - radius);
                    CGContextAddArc(context, r.size.width - radius, r.size.height - radius, radius, 0.0, M_PI_2, 0);
                    
                    // 绘制第3条线和第3个1/4圆弧
                    CGContextAddLineToPoint(context, radius, r.size.height);
                    CGContextAddArc(context, radius, r.size.height - radius, radius, M_PI_2, M_PI, 0);
                    
                    // 绘制第4条线和第4个1/4圆弧
                    CGContextAddLineToPoint(context, 0, radius);
                    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
                    
                    // 闭合路径
                    CGContextClosePath(context);
                    CGContextDrawPath(context, kCGPathStroke);
                }
                
            }
            
            CGContextRestoreGState(context);
            
        }
        
    }
    
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    
    CGSize size = self.frame.size;
    CGRect r = CGRectMake(0, 0, size.width, size.height);
    
    UIColor * backgroundColor = [self colorValueForKey:@"background-color"];
    
    if(backgroundColor){
        
        CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
        CGContextSetStrokeColorWithColor(context, [backgroundColor CGColor]);
        
        CGContextFillRect(context, r);
    }

    UIImage * backgroundImage = [self imageValueForKey:@"background-image" bundle:self.document.bundle];
    
    if(backgroundImage ){
        
        CGSize imageSize = backgroundImage.size;
        CGFloat left = backgroundImage.leftCapWidth / imageSize.width;
        CGFloat top = backgroundImage.topCapHeight / imageSize.height;
        
        if(left && top){
            CALayer * bgLayer = [self layer];
            bgLayer.frame = r;
            bgLayer.contents = (id)[backgroundImage CGImage];
            bgLayer.contentsScale = [backgroundImage scale];
            bgLayer.contentsRect = CGRectMake(0, 0, 1.0, 1.0);
            bgLayer.contentsCenter  = CGRectMake(left, top, 1.0 / imageSize.width, 1.0 / imageSize.height);
            
            [bgLayer renderInContext:context];
        }
        else{
            [backgroundImage drawInRect:r];
        }

    }

}

-(CALayer *) layer{
    static CALayer * layer = nil;
    if(layer == nil){
        layer = [[CALayer alloc] init];
    }
    return layer;
}

@end
