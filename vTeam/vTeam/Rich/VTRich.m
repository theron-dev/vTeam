//
//  VTRich.m
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTRich.h"


@implementation VTRichElement

@synthesize range = _range;

@end

@interface VTRich(){
    NSMutableAttributedString * _attributedString;
    NSMutableArray * _elements;
    struct {
        CTFrameRef frame;
        CGFloat width;
        CTFramesetterRef framesetter;
    } _frameWithWidth;
}

@end

static void VTRichCTRunDelegateDeallocateCallback (void* refCon ){

}

static CGFloat VTRichCTRunDelegateGetAscentCallback ( void* refCon ){
    return [(id) refCon ascent];
}

static CGFloat VTRichCTRunDelegateGetDescentCallback (void* refCon ){
    return [(id) refCon descent];
}

static CGFloat VTRichCTRunDelegateGetWidthCallback (void* refCon ){
    return [(id) refCon width];
}

static CTRunDelegateCallbacks VTRichDelegateCallbacks = {
    kCTRunDelegateVersion1
    ,VTRichCTRunDelegateDeallocateCallback
    ,VTRichCTRunDelegateGetAscentCallback
    ,VTRichCTRunDelegateGetDescentCallback
    ,VTRichCTRunDelegateGetWidthCallback};

@implementation VTRich

@synthesize attributedString = _attributedString;
@synthesize elements = _elements;
@synthesize font = _font;
@synthesize incFontSize = _incFontSize;
@synthesize textColor = _textColor;
@synthesize linesSpacing = _linesSpacing;

-(id) init{
    if((self = [super init])){
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blackColor];
        self.linesSpacing = 3;
    }
    return self;
}

-(void) dealloc{
    [_attributedString release];
    [_elements release];
    [_textColor release];
    [_font release];
    if(_frameWithWidth.frame){
        CFRelease(_frameWithWidth.frame);
    }
    if(_frameWithWidth.framesetter){
        CFRelease(_frameWithWidth.framesetter);
    }
    [super dealloc];
}

-(NSArray *) elements{
    if(_elements == nil){
        _elements = [[NSMutableArray alloc] initWithCapacity:4];
    }
    return _elements;
}

-(NSAttributedString *) attributedString{
    if(_attributedString){
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    return _attributedString;
}


-(void) setAttributes:(NSDictionary *) attributes element:(id<IVTRichElement>) element{
    [_attributedString setAttributes:attributes range:[element range]];
}

-(void) appendElement:(id<IVTRichElement>) element text:(NSString *) text attributes:(NSDictionary *) attributes{
    
    NSRange range = {[self.attributedString length],[text length]};
    
    [element setRange:range];
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    CTFontRef font = (CTFontRef)[attr valueForKey:(id)kCTFontAttributeName];
    
    if(font){
        if(_incFontSize){
            font = CTFontCreateCopyWithAttributes(font, CTFontGetSize(font) + _incFontSize, nil, nil);
            [attr setValue:(id)font forKey:(id)kCTFontAttributeName];
            CFRelease(font);
        }
    }
    else{
        font = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize + _incFontSize, nil);
        [attr setValue:(id)font forKey:(id)kCTFontAttributeName];
        CFRelease(font);
    }
    
    CGColorRef textColor = (CGColorRef)[attr valueForKey:(id)kCTForegroundColorAttributeName];
    
    if(textColor == nil){
        [attr setValue:(id)_textColor.CGColor forKey:(id)kCTForegroundColorAttributeName];
    }
    
    if([element conformsToProtocol:@protocol(IVTRichDrawElement)] || [element conformsToProtocol:@protocol(IVTRichViewElement)]){
        
        CTRunDelegateRef delegate = CTRunDelegateCreate(&VTRichDelegateCallbacks, element);
        
        [attributes setValue:(id)delegate forKey:(id)kCTRunDelegateAttributeName];
        
        CFRelease(delegate);
    }
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:text attributes:attr];
    
    [_attributedString appendAttributedString:string];
    
    if(_frameWithWidth.frame){
        CFRelease(_frameWithWidth.frame);
        _frameWithWidth.frame = nil;
    }
    
    if(_frameWithWidth.framesetter){
        CFRelease(_frameWithWidth.framesetter);
        _frameWithWidth.framesetter = nil;
    }

}

-(void) appendElement:(id<IVTRichElement>) element{
    [self appendElement:element text:@" " attributes:nil];
}

-(id<IVTRichElement>) appendText:(NSString *) text attributes:(NSDictionary *) attributes{
    VTRichElement * element= [[VTRichElement alloc] init];
    [self appendElement:element text:text attributes:attributes];
    return [element autorelease];
}

-(void) removeAllElements{
    NSRange r = {0,[_attributedString length]};
    [_attributedString deleteCharactersInRange:r];
    [_elements removeAllObjects];
    if(_frameWithWidth.frame){
        CFRelease(_frameWithWidth.frame);
        _frameWithWidth.frame = nil;
    }
    if(_frameWithWidth.framesetter){
        CFRelease(_frameWithWidth.framesetter);
        _frameWithWidth.framesetter = nil;
    }
}

-(CTFrameRef) frameWithWidth:(CGFloat) width{
    if(_frameWithWidth.frame == nil || _frameWithWidth.width != width){
        
        if(_frameWithWidth.frame){
            CFRelease(_frameWithWidth.frame);
        }
        
        _frameWithWidth.width = width;
        
        if(_frameWithWidth.framesetter == nil){
            _frameWithWidth.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, nil, CGRectMake(0, 0, width, MAXFLOAT));
        
        CFRange r = {0,[_attributedString length]};
        
        NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithCapacity:4];
        
        [attr setValue:[NSNumber numberWithFloat:_linesSpacing] forKey:(id)kCTParagraphStyleSpecifierLineSpacingAdjustment];
        
        _frameWithWidth.frame = CTFramesetterCreateFrame(_frameWithWidth.framesetter, r, path, (CFDictionaryRef)attr);
        
        CFRelease(path);

    }
    return _frameWithWidth.frame;
}

-(CGSize) contentSizeWithWidth:(CGFloat) width{
    
    if(_frameWithWidth.framesetter == nil){
        _frameWithWidth.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    }
    
    NSMutableDictionary * attr = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [attr setValue:[NSNumber numberWithFloat:_linesSpacing] forKey:(id)kCTParagraphStyleSpecifierLineSpacingAdjustment];
    
    CFRange r = {0,[_attributedString length]};
    
    return CTFramesetterSuggestFrameSizeWithConstraints(_frameWithWidth.framesetter, r, (CFDictionaryRef)attr, CGSizeMake(width, MAXFLOAT), nil);
}


@end
