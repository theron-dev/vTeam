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

#import "NSString+TextLength.h"

@interface VTDOMRichElement(){
    NSMutableArray * _highlightedLayers;
}

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
    
    NSString * maxLength = [element stringValueForKey:@"max-length"];
    
    if(maxLength){
        
        NSInteger length = [text textIndexOfLength:[maxLength intValue]];
        
        if(length < [text length]){
            text = [[text substringToIndex:length] stringByAppendingFormat:@"..."];
        }
    }
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    UIFont * font = [element elementFont:nil];
    
    if(font){
        CTFontRef f = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize + rich.incFontSize, nil);
        [attr setValue:(id)f forKey:(id)kCTFontAttributeName];
        CFRelease(f);
    }
    
    UIColor * textColor = [element colorValueForKey:@"color"];
    
    if(textColor){
        [attr setValue:(id) textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    UIColor * bgColor = [element colorValueForKey:@"background-color"];
    
    if(bgColor){
        [attr setValue:(id) bgColor.CGColor forKey:(id)VTBackgroundColorAttributeName];
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
        
        if([name isEqualToString:@"p"] || [name isEqualToString:@"div"]){
            if(![rich isNewLine]){
                [rich appendText:@"\n" attributes:attr];
            }
        }
        
        if([text length]){
            
            if(! [self willAppendText:text attributes:attr rich:rich]){
                [rich appendText:text attributes:attr];
            }
            
        }

        for(VTDOMElement * el in [element childs]){
            [self elementToRichElement:el rich:rich attributes:attr];
        }
        
        if([name isEqualToString:@"p"] || [name isEqualToString:@"div"]){
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
        _rich.firstLineHeadIndent = [self floatValueForKey:@"indent"];
        _rich.paragraphSpacing = [self floatValueForKey:@"paragraph-spacing"];
        
        NSString * align = [self stringValueForKey:@"align"];

        if([align isEqualToString:@"left"]){
            _rich.textAlignment = kCTTextAlignmentLeft;
        }
        else if([align isEqualToString:@"right"]){
            _rich.textAlignment = kCTTextAlignmentRight;
        }
        else if([align isEqualToString:@"center"]){
            _rich.textAlignment = kCTTextAlignmentCenter;
        }
        else if([align isEqualToString:@"natural"]){
            _rich.textAlignment = kCTTextAlignmentNatural;
        }

        
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
    return [self elementFont:[UIFont systemFontOfSize:14]];
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

    [self.rich drawContext:context withSize:self.frame.size];
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
        
        UIColor * actionColor = [self colorValueForKey:@"action-color"];
        
        if(actionColor == nil){
            actionColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
        }
        
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
                    layer.backgroundColor = actionColor.CGColor;
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

-(void) elementDidAppera:(VTDOMElement *)element{
    [super elementDidAppera:element];
    [self setRich:nil];
}

-(void) elementDidDisappera:(VTDOMElement *)element{
    [super elementDidDisappera:element];
    [self setRich:nil];
}


-(void) unbindDelegate:(id)delegate{
    if(self.delegate == delegate){
        self.delegate = nil;
    }
}

-(void) bindDelegate:(id)delegate{
    self.delegate = delegate;
    for(VTDOMElement * el in [self childs]){
        [el bindDelegate:self];
    }
}

-(void) vtDOMElementDoAction:(VTDOMElement *) element{
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
        [delegate vtDOMElementDoAction:element];
    }
}

-(void) vtDOMElementDoNeedDisplay:(VTDOMElement *) element{
    
    [self setRich:nil];
    
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElementDoNeedDisplay:)]){
        [delegate vtDOMElementDoNeedDisplay:element];
    }
}

-(void) vtDOMElement:(VTDOMElement *) element addLayer:(CALayer *) layer frame:(CGRect) frame{
    
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElement:addLayer:frame:)]){
        [delegate vtDOMElement:element addLayer:layer frame:frame];
    }
}

-(void) vtDOMElement:(VTDOMElement *) element addView:(UIView *) view frame:(CGRect) frame{
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElement:addView:frame:)]){
        [delegate vtDOMElement:element addView:view frame:frame];
    }
}

-(CGRect) vtDOMElement:(VTDOMElement *) element convertRect:(CGRect) rect{
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElement:convertRect:)]){
        return [delegate vtDOMElement:element convertRect:rect];
    }
    return rect;
}

-(UIView *) vtDOMElementView:(VTDOMElement *) element viewClass:(Class)viewClass{
    id delegate = [self delegate];
    if([delegate respondsToSelector:@selector(vtDOMElementView:viewClass:)]){
        return [delegate vtDOMElementView:element viewClass:viewClass];
    }
    return nil;
}

-(BOOL) willAppendText:(NSString *)text attributes:(NSDictionary *)attributes rich:(VTRich *) rich{
    return NO;
}

@end
