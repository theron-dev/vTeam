//
//  VTRich.h
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreText/CoreText.h>

extern NSString * VTBackgroundColorAttributeName;

@protocol IVTRichElement <NSObject>

@property(nonatomic,assign) NSRange range;
@property(nonatomic,retain) id userInfo;

@end

@interface VTRichElement : NSObject<IVTRichElement>

@end

@protocol IVTRichDrawElement <IVTRichElement>

@property(nonatomic,readonly) CGFloat width;
@property(nonatomic,readonly) CGFloat ascent;
@property(nonatomic,readonly) CGFloat descent;

-(void) drawRect:(CGRect) rect context:(CGContextRef) context;

@end

@protocol IVTRichViewElement <IVTRichElement>

@property(nonatomic,readonly) CGFloat width;
@property(nonatomic,readonly) CGFloat ascent;
@property(nonatomic,readonly) CGFloat descent;

@property(nonatomic,retain) UIView * view;

@end

@interface VTRich : NSObject

@property(nonatomic,retain) UIFont * font;
@property(nonatomic,assign) CGFloat incFontSize;
@property(nonatomic,retain) UIColor * textColor;
@property(nonatomic,assign) CGFloat linesSpacing;
@property(nonatomic,assign) CGFloat charsetsSpacing;
@property(nonatomic,assign) CGFloat firstLineHeadIndent;
@property(nonatomic,assign) CTTextAlignment textAlignment;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic,readonly) NSArray * elements;
@property(nonatomic,readonly) NSAttributedString * attributedString;
@property(nonatomic,readonly,getter = isNewLine) BOOL newLine;

-(void) setAttributes:(NSDictionary *) attributes element:(id<IVTRichElement>) element;

-(void) appendElement:(id<IVTRichElement>) element text:(NSString *) text attributes:(NSDictionary *) attributes;

-(void) appendElement:(id<IVTRichElement>) element;

-(void) appendText:(NSString *) text attributes:(NSDictionary *) attributes;

-(void) removeAllElements;

-(CTFrameRef) frameWithSize:(CGSize) size;

-(CGSize) contentSizeWithSize:(CGSize) size;

-(void) drawContext:(CGContextRef) context withSize:(CGSize) size;

-(id) elementByLocation:(CGPoint) location withSize:(CGSize) size;

-(NSArray *) elementRects:(id) element withSize:(CGSize) size;

-(void) installView:(UIView *) view rect:(CGRect) rect;

-(void) uninstallView;

-(void) drawElement:(id<IVTRichDrawElement>) element context:(CGContextRef) context withSize:(CGSize) size;

@end
