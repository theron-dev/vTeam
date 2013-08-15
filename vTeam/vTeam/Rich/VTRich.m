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
        CGSize size;
        CTFramesetterRef framesetter;
    } _frameWithSize;
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
@synthesize charsetsSpacing = _charsetsSpacing;

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
    if(_frameWithSize.frame){
        CFRelease(_frameWithSize.frame);
    }
    if(_frameWithSize.framesetter){
        CFRelease(_frameWithSize.framesetter);
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
    
    if([attr valueForKey:(id)kCTKernAttributeName] == nil){
        [attr setValue:[NSNumber numberWithFloat:_charsetsSpacing] forKey:(id)kCTKernAttributeName];
    }
    
    if([element conformsToProtocol:@protocol(IVTRichDrawElement)] || [element conformsToProtocol:@protocol(IVTRichViewElement)]){
        
        CTRunDelegateRef delegate = CTRunDelegateCreate(&VTRichDelegateCallbacks, element);
        
        [attr setValue:(id)delegate forKey:(id)kCTRunDelegateAttributeName];
        
        CFRelease(delegate);
    }
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:text attributes:attr];
    
    [_attributedString appendAttributedString:string];
    
    [string release];
    
    if(element){
        [self elements];
        [_elements addObject:element];
    }
    
    if(_frameWithSize.frame){
        CFRelease(_frameWithSize.frame);
        _frameWithSize.frame = nil;
    }
    
    if(_frameWithSize.framesetter){
        CFRelease(_frameWithSize.framesetter);
        _frameWithSize.framesetter = nil;
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
    if(_frameWithSize.frame){
        CFRelease(_frameWithSize.frame);
        _frameWithSize.frame = nil;
    }
    if(_frameWithSize.framesetter){
        CFRelease(_frameWithSize.framesetter);
        _frameWithSize.framesetter = nil;
    }
}

-(CTFrameRef) frameWithSize:(CGSize) size{
    
    if(_frameWithSize.frame == nil || !CGSizeEqualToSize(size, _frameWithSize.size)){
        
        if(_frameWithSize.frame){
            CFRelease(_frameWithSize.frame);
        }
        
        _frameWithSize.size = size;
        
        if(_frameWithSize.framesetter == nil){
            _frameWithSize.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        
        CFRange r = {0,[_attributedString length]};
 
        _frameWithSize.frame = CTFramesetterCreateFrame(_frameWithSize.framesetter, r, path, nil);
        
        CGPathRelease(path);
    }
    
    return _frameWithSize.frame;
}

-(CGSize) contentSizeWithSize:(CGSize) size{
    
    if(_frameWithSize.framesetter == nil){
        _frameWithSize.framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    }
    

    CFRange r = {0,[_attributedString length]};
    
    return CTFramesetterSuggestFrameSizeWithConstraints(_frameWithSize.framesetter, r
                                                        , nil, size, nil);
}

-(BOOL) isNewLine{
    if([_attributedString.string length]){
        return [[_attributedString.string substringFromIndex:[_attributedString.string length] -1] isEqualToString:@"\n"];
    }
    return NO;
}

-(void) drawContext:(CGContextRef) context withSize:(CGSize) size{

    CTFrameRef frame = [self frameWithSize:size];
    
    CTFrameDraw(frame, context);
    
    NSInteger elementIndex = 0;
    NSInteger lineIndex = 0;
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger count = CFArrayGetCount(lines);
    NSArray * elements = [self elements];
    id drawElement = nil;
    CGPoint lineOrigins[count];
    
    while(elementIndex < [elements count] && drawElement == nil){
        drawElement = [elements objectAtIndex:elementIndex ++];
        if(![drawElement conformsToProtocol:@protocol(IVTRichDrawElement)]){
            drawElement = nil;
        }
    }
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    while(lineIndex < count && drawElement){
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CFArrayRef runs = CTLineGetGlyphRuns(line);

        for(int i=0;i<CFArrayGetCount(runs);i++){
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            
            CFRange r = CTRunGetStringRange(run);
            
            NSRange rr = [drawElement range];
            
            if(r.location == rr.location && r.length == rr.length && r.length == 1){
                
                const CGPoint * p = CTRunGetPositionsPtr(run);
                
                CGSize s = CGSizeMake([drawElement width], [drawElement ascent] + [drawElement descent]);
                
                CGContextSaveGState(context);
                
                CGContextTranslateCTM(context, p->x, p->y + lineOrigins[lineIndex].y);
                CGContextClipToRect(context, CGRectMake(0, 0, s.width, s.height));
                
                [drawElement drawRect:CGRectMake(0, 0, s.width, s.height) context:context];
                
                CGContextRestoreGState(context);
                
                
                drawElement = nil;
                while(elementIndex < [elements count] && drawElement == nil){
                    drawElement = [elements objectAtIndex:elementIndex ++];
                    if(![drawElement conformsToProtocol:@protocol(IVTRichDrawElement)]){
                        drawElement = nil;
                    }
                }
            }
            else if(r.location>= r.location + r.length){
                drawElement = nil;
                while(elementIndex < [elements count] && drawElement == nil){
                    drawElement = [elements objectAtIndex:elementIndex ++];
                    if(![drawElement conformsToProtocol:@protocol(IVTRichDrawElement)]){
                        drawElement = nil;
                    }
                }
            }
            
        }
                                                                        
        lineIndex ++;
        
    }
    
}

-(id) elementByLocation:(CGPoint) location withSize:(CGSize) size{
    
    CTFrameRef frame = [self frameWithSize:size];
    
    NSInteger lineIndex = 0;
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    while(lineIndex < count ){
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);

        CGRect bounds = CTLineGetBoundsWithOptions(line, kCTLineBoundsUseOpticalBounds);
        bounds.origin.y = lineOrigins[0].y - lineOrigins[lineIndex].y - bounds.origin.y;
        
        if(CGRectContainsPoint(bounds, location)){
            CFIndex index = CTLineGetStringIndexForPosition(line, location);
            
            if(index != kCFNotFound){
                
                for(id element in [self elements]){
                    
                    NSRange rr = [element range];
                    
                    if(index >= rr.location && index <= rr.location +rr.length){
                        return element;
                    }
                    else if(index < rr.location){
                        break;
                    }
                }
                
                break;
            }
        }
    
        lineIndex ++;
        
    }
    
    return nil;
}

-(NSArray *) elementRects:(id) element withSize:(CGSize) size{
    
    if(element){
        
        NSMutableArray * rects = [NSMutableArray arrayWithCapacity:4];
        
        CTFrameRef frame = [self frameWithSize:size];
        
        NSInteger lineIndex = 0;
        CFArrayRef lines = CTFrameGetLines(frame);
        NSInteger count = CFArrayGetCount(lines);
        CGPoint lineOrigins[count];
        
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
        
        NSRange range = [element range];
        NSInteger index = 0;
        
        while(lineIndex < count && index < range.length){
            
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            
            CFRange r = CTLineGetStringRange(line);
            CGRect bounds = CTLineGetBoundsWithOptions(line, kCTLineBoundsUseOpticalBounds);
            
            CGRect rect = CGRectMake(0, lineOrigins[0].y - lineOrigins[lineIndex].y - bounds.origin.y
                                     , 0, bounds.size.height);
            CGFloat beginOffset = kCFNotFound;
            CGFloat endOffset = kCFNotFound;
       
            if (range.location + index >= r.location && range.location + index < r.location + r.length
                   && index < range.length) {
                
                if(beginOffset == kCFNotFound){
                    beginOffset = CTLineGetOffsetForStringIndex(line, range.location + index, NULL);
                }
                
                if(range.location + range.length <= r.location + r.length){
                    index = range.length;
                    endOffset = CTLineGetOffsetForStringIndex(line, range.location + index, NULL);
                }
                else{
                    endOffset = bounds.size.width;
                    index = r.length - (range.location - r.location);
                }
            }
            
            if(beginOffset != kCFNotFound && endOffset != kCFNotFound){
                
                rect.origin.x = beginOffset;
                rect.size.width = endOffset - beginOffset;

                [rects addObject:[NSValue valueWithCGRect:rect]];
                
            }
            
            lineIndex ++;
            
        }
        
        return rects;
    }
    
    return nil;
}

-(void) installView:(UIView *) view rect:(CGRect) rect{
    
    CTFrameRef frame = [self frameWithSize:rect.size];
    
    NSInteger elementIndex = 0;
    NSInteger lineIndex = 0;
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger count = CFArrayGetCount(lines);
    NSArray * elements = [self elements];
    id viewElement = nil;
    CGPoint lineOrigins[count];
    
    while(elementIndex < [elements count] && viewElement == nil){
        viewElement = [elements objectAtIndex:elementIndex ++];
        if(![viewElement conformsToProtocol:@protocol(IVTRichViewElement)]){
            viewElement = nil;
        }
    }
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    while(lineIndex < count && viewElement){
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for(int i=0;i<CFArrayGetCount(runs);i++){
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            
            CFRange r = CTRunGetStringRange(run);
            
            NSRange rr = [viewElement range];
            
            if(r.location == rr.location && r.length == rr.length && r.length == 1){
                
                const CGPoint * p = CTRunGetPositionsPtr(run);
                
                CGRect r = CGRectMake(rect.origin.x + p->x, rect.origin.y + p->y + lineOrigins[lineIndex].y, [viewElement width], [viewElement ascent] + [viewElement descent]);
                
                UIView * v = [viewElement view];
                
                if(v){
                    v.frame = r;
                    [view addSubview:v];
                }
                
                viewElement = nil;
                while(elementIndex < [elements count] && viewElement == nil){
                    viewElement = [elements objectAtIndex:elementIndex ++];
                    if(![viewElement conformsToProtocol:@protocol(IVTRichViewElement)]){
                        viewElement = nil;
                    }
                }
            }
            else if(r.location>= r.location + r.length){
                viewElement = nil;
                while(elementIndex < [elements count] && viewElement == nil){
                    viewElement = [elements objectAtIndex:elementIndex ++];
                    if(![viewElement conformsToProtocol:@protocol(IVTRichViewElement)]){
                        viewElement = nil;
                    }
                }
            }
            
        }
        
        lineIndex ++;
        
    }
}

-(void) uninstallView{
    for(id element in [self elements]){
        if([element conformsToProtocol:@protocol(IVTRichViewElement)]){
            [[element view] removeFromSuperview];
        }
    }
}

-(void) drawElement:(id<IVTRichDrawElement>) element context:(CGContextRef) context withSize:(CGSize) size{
    
    CTFrameRef frame = [self frameWithSize:size];
 
    NSInteger lineIndex = 0;
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    while(lineIndex < count && element){
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for(int i=0;i<CFArrayGetCount(runs);i++){
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            
            CFRange r = CTRunGetStringRange(run);
            
            NSRange rr = [element range];
            
            if(r.location == rr.location && r.length == rr.length && r.length == 1){
                
                const CGPoint * p = CTRunGetPositionsPtr(run);
                
                CGSize s = CGSizeMake([element width], [element ascent] + [element descent]);
                
                CGContextSaveGState(context);
                
                CGContextTranslateCTM(context, p->x, p->y + lineOrigins[lineIndex].y);
                CGContextClipToRect(context, CGRectMake(0, 0, s.width, s.height));
                
                [element drawRect:CGRectMake(0, 0, s.width, s.height) context:context];
                
                CGContextRestoreGState(context);
                
                element = nil;
            }
            else if(r.location>= r.location + r.length){
                element = nil;
            }
            
        }
        
        lineIndex ++;
        
    }
    
}

@end
