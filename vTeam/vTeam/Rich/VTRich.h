//
//  VTRich.h
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreText/CoreText.h>

@protocol IVTRichElement <NSObject>

@property(nonatomic,assign) NSRange range;

@end

@protocol IVTRichLinkElement <IVTRichElement>

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
@property(nonatomic,readonly) NSArray * elements;
@property(nonatomic,readonly) NSAttributedString * attributedString;

-(void) setAttributes:(NSDictionary *) attributes element:(id<IVTRichElement>) element;

-(void) appendElement:(id<IVTRichElement>) element text:(NSString *) text attributes:(NSDictionary *) attributes;

-(void) appendElement:(id<IVTRichElement>) element;

-(void) appendText:(NSString *) text attributes:(NSDictionary *) attributes;

-(void) removeAllElements;

-(CTFrameRef) frameWithSize:(CGSize) size;

-(CGSize) contentSizeWithSize:(CGSize) size;

@end
