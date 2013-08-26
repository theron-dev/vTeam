//
//  VTDOMRichElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMRichElement.h"

#import "VTRich.h"
#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMElement+Layout.h"
#import "VTDOMElement+Control.h"
#import "VTDOMDocument.h"
#import "VTRichImageElement.h"
#import "VTRichLinkElement.h"
#import "VTRichViewElement.h"

#import "VTDOMImageElement.h"
#import "VTDOMViewElement.h"

#import <QuartzCore/QuartzCore.h>

@interface VTDOMRichElement(){
    NSMutableArray * _highlightedLayers;
}

@property(nonatomic,readonly) VTRich * rich;
@property(nonatomic,retain) id focusElement;

@end

@implementation VTDOMRichElement

@synthesize rich = _rich;
@synthesize focusElement = _focusElement;

-(void) dealloc{
    for(CALayer * layer in _highlightedLayers){
        [layer removeFromSuperlayer];
    }
    [_highlightedLayers release];
    [_focusElement release];
    [_rich release];
    [super dealloc];
}

-(void) elementToRichElement:(VTDOMElement *) element rich:(VTRich *) rich attributes:(NSDictionary *) attributes{
    
    NSString * text = [element text];
    NSString * name = [element name];
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    UIFont * font = [element fontValueForKey:@"font"];
    
    if(font == nil){
        NSString * v = [element stringValueForKey:@"font-size"];
        if(v){
            font = [UIFont systemFontOfSize:[v floatValue]];
        }
    }
    
    if(font){
        CTFontRef f = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize + rich.incFontSize, nil);
        [attr setValue:(id)f forKey:(id)kCTFontAttributeName];
        CFRelease(f);
    }
    
    UIColor * textColor = [element colorValueForKey:@"color"];
    
    if(textColor){
        [attr setValue:(id) textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    if([name isEqualToString:@"br"]){
        if(![rich isNewLine]){
            [rich appendText:@"\n" attributes:attr];
        }
    }
    else if([element isKindOfClass:[VTDOMImageElement class]]){
        
        VTRichImageElement * img = [[VTRichImageElement alloc] init];
        
        [img setUserInfo:element];
        
        [img setImage:[(VTDOMImageElement *)element image]];
        
        CGSize size = img.image.size;
        CGFloat dr = size.width ? size.height / size.width : 0;
        CGRect r = self.frame;
        
        NSString * width = [element stringValueForKey:@"width"];
        NSString * height = [element stringValueForKey:@"height"];
        
        if(width && ![width isEqualToString:@"auto"]){
            if([width hasSuffix:@"%"]){
                size.width = [width floatValue] * r.size.width / 100.0;
            }
            else{
                size.width = [width floatValue];
            }
        }
        
        if(height && ![height isEqualToString:@"auto"]){
            if([height hasSuffix:@"%"]){
                size.height = [height floatValue] * r.size.height / 100.0;
            }
            else{
                size.height = [height floatValue];
            }
        }
        else if(dr){
            size.height = size.width * dr;
        }
        
        [img setSize:size];
        
        [rich appendElement:img];
        
        [img release];
        
    }
    else if([element isKindOfClass:[VTDOMViewElement class]]){
        
        VTRichViewElement * viewElement = [[VTRichViewElement alloc] init];
        
        [viewElement setUserInfo:element];
        
        UIView * view = [(VTDOMViewElement *)element view];
        
        [viewElement setView:view];
        
        CGRect frame = view.frame;
        CGSize size = frame.size;
        CGRect r = self.frame;
        
        NSString * width = [element stringValueForKey:@"width"];
        NSString * height = [element stringValueForKey:@"height"];
        
        if(width && ![width isEqualToString:@"auto"]){
            if([width hasSuffix:@"%"]){
                size.width = [width floatValue] * r.size.width / 100.0;
            }
            else{
                size.width = [width floatValue];
            }
        }
        else {
            frame.size.width = 0;
            [view setFrame:frame];
            [view sizeToFit];
            size.width = view.frame.size.width;
        }
        
        if(height && ![height isEqualToString:@"auto"]){
            if([height hasSuffix:@"%"]){
                size.height = [height floatValue] * r.size.height / 100.0;
            }
            else{
                size.height = [height floatValue];
            }
        }
        else{
            frame.size.height = 0;
            frame.size.width = size.width;
            [view sizeToFit];
            size.height = view.frame.size.height;
        }
        
        [viewElement setSize:size];
        
        [rich appendElement:viewElement];
        
        [viewElement release];
        
    }
    else if([name isEqualToString:@"a"] && [text length]){
        VTRichLinkElement * link = [[VTRichLinkElement alloc] init];
        [link setUserInfo:element];
        [link setHref:[element stringValueForKey:@"href"]];
        [rich appendElement:link text:text attributes:attr];
        [link release];
    }
    else{
        
        if([name isEqualToString:@"p"]){
            if(![rich isNewLine]){
                [rich appendText:@"\n" attributes:attr];
            }
        }
        
        if([text length]){
            [rich appendText:text attributes:attr];
        }

        for(VTDOMElement * el in [element childs]){
            [self elementToRichElement:el rich:rich attributes:attr];
        }
        
        if([name isEqualToString:@"p"]){
            if(![rich isNewLine]){
                [rich appendText:@"\n" attributes:attr];
            }
        }
    }
}

-(VTRich *) rich{
    if(_rich == nil){
        
        _rich = [[VTRich alloc] init];
        
        _rich.font = [self font];
        _rich.textColor = [self textColor];
        _rich.linesSpacing = [self floatValueForKey:@"line-spacing"];
        _rich.charsetsSpacing = [self floatValueForKey:@"charset-spacing"];
        
        NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithCapacity:4];
        
        CTFontRef font = CTFontCreateWithName((CFStringRef)_rich.font.fontName, _rich.font.pointSize + _rich.incFontSize, nil);
        [attr setValue:(id)font forKey:(id)kCTFontAttributeName];
        CFRelease(font);
        
        [attr setValue:(id)_rich.textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
        
        [self elementToRichElement:self rich:_rich attributes:attr];

    }
    return _rich;
}

-(UIFont *) font{
    UIFont * font = [self fontValueForKey:@"font"];
    
    if(font == nil){
        CGFloat fontSize = [self floatValueForKey:@"font-size"];
        if(fontSize == 0){
            fontSize = 14;
        }
        font = [UIFont systemFontOfSize:14];
    }
    
    return font;
}

-(UIColor *) textColor{
    
    UIColor * color = [self colorValueForKey:@"color"];
    
    if(color == nil){
        color = [UIColor blackColor];
    }
    
    return color;
}

-(void) render:(CGRect)rect context:(CGContextRef)context{
    [self draw:rect context:context];
}

-(void) draw:(CGRect)rect context:(CGContextRef)context{
    [super draw:rect context:context];

    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    [_rich drawContext:context withSize:self.frame.size];
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        CGSize s = [self.rich contentSizeWithSize:r.size];
        
        if(r.size.width == MAXFLOAT){
            r.size.width = s.width;
        }
        
        if(r.size.height == MAXFLOAT){
            r.size.height = s.height;
        }
        
        [self setFrame:r];
        
    }
    return r.size;
}

-(BOOL) touchesBegan:(CGPoint)location{
    self.focusElement = [_rich elementByLocation:location withSize:self.frame.size];
    if(![_focusElement isKindOfClass:[VTRichLinkElement class]]){
        self.focusElement = nil;
    }
    BOOL rs = [super touchesBegan:location];
    if( _focusElement){
        return YES;
    }
    return rs;
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(highlighted && _focusElement){
        
        NSMutableArray * layers = nil;
        
        if(_highlightedLayers== nil){
            _highlightedLayers = [[NSMutableArray alloc] initWithCapacity:4];
        }
        else{
            layers = [NSMutableArray arrayWithArray:_highlightedLayers];
            [_highlightedLayers removeAllObjects];
        }
        
        NSArray * rects = [_rich elementRects:_focusElement withSize:self.frame.size];
        
        NSInteger index = 0;
        
        CALayer * superLayer = nil;
        
        if([self.delegate isKindOfClass:[UIView class]]){
            superLayer = [(UIView *)self.delegate layer];
        }
        else if([self.delegate isKindOfClass:[CALayer class]]){
            superLayer = (CALayer *) self.delegate;
        }
        
        if([self.delegate respondsToSelector:@selector(vtDOMElement:addLayer:frame:)]){
            
            for(id rect in rects){
                
                CALayer * layer = index < [layers count] ? [layers objectAtIndex:index] : nil;
                
                if(layer == nil){
                    layer = [[CALayer alloc] init];
                    layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
                    layer.cornerRadius = 3;
                    layer.masksToBounds = YES;
                }
                
                CGRect r = [rect CGRectValue];
                
                [self.delegate vtDOMElement:self addLayer:layer frame:r];
                
                [_highlightedLayers addObject:layer];
                
                index ++;
                
            }
            
        }
        
        while(index < [layers count]){
            [[layers objectAtIndex:index] removeFromSuperlayer];
            index ++;
        }
        
    }
    else{
        for(CALayer * layer in _highlightedLayers){
            [layer removeFromSuperlayer];
        }
        [_highlightedLayers removeAllObjects];
    }
}

-(void) touchesEnded:(CGPoint)location{
    
    if([self isHighlighted]){
        if([_focusElement userInfo]){
            if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
                [self.delegate vtDOMElementDoAction:(VTDOMElement *)[_focusElement userInfo]];
            }
        }
    }
    
    [super touchesEnded:location];
}

-(void) touchesCancelled:(CGPoint)location{
    
    self.focusElement = nil;
    
    [super touchesCancelled:location];
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    for(CALayer * layer in _highlightedLayers){
        [layer removeFromSuperlayer];
    }
    self.focusElement = nil;
}

-(NSString *) actionName{
    return [self attributeValueForKey:@"action-name"];
}

-(void) setActionName:(NSString *)actionName{
    [self setAttributeValue:actionName forKey:@"action-name"];
}

-(id) userInfo{
    return [self attributeValueForKey:@"user-info"];
}

-(void) setUserInfo:(id)userInfo{
    [self setAttributeValue:userInfo forKey:@"user-info"];
}

-(NSArray *) actionViews{
    return nil;
}

-(void) setActionViews:(NSArray *)actionViews{
    
}

@end
