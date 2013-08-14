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
    if(_attributedString == nil){
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
    
    if([attr valueForKey:(id)kCTParagraphStyleAttributeName] == nil){
        
        CTTextAlignment textAlignment = kCTTextAlignmentJustified;
        CGFloat firstLineHeadIndent = 0;
        
        CTParagraphStyleSetting settings[] = {
            {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(_linesSpacing),&_linesSpacing},
            {kCTParagraphStyleSpecifierAlignment,sizeof(textAlignment),&textAlignment},
            {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(firstLineHeadIndent),&firstLineHeadIndent},
        };
        
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting)) ;
        
        [attr setValue:(id)style forKey:(id)kCTParagraphStyleAttributeName];
        
        CFRelease(style);
        
    }
    
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
    
    [string release];
    
    if(element){
        [self elements];
        [_elements addObject:element];
    }
    
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

-(void) appendText:(NSString *) text attributes:(NSDictionary *) attributes{
    [self appendElement:nil text:text attributes:attributes];
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
        
        CGPathAddRect(path, NULL, CGRectMake(0, 0, width, MAXFLOAT));
        
        CFRange r = {0,[_attributedString length]};
 
        _frameWithWidth.frame = CTFramesetterCreateFrame(_frameWithWidth.framesetter, r, path, nil);
        
        CGPathRelease(path);
    }
    
    return _frameWithWidth.frame;
}

-(CGSize) contentSizeWithWidth:(CGFloat) width{
    
    if(_frameWithWidth.framesetter == nil){
        _frameWithWidth.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    }
    

    CFRange r = {0,[_attributedString length]};
    
    return CTFramesetterSuggestFrameSizeWithConstraints(_frameWithWidth.framesetter, r
                                                        , nil, CGSizeMake(width, MAXFLOAT), nil);
}

@end
