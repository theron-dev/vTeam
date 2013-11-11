//
//  Grid.m
//  vTeam
//
//  Created by zhang hailong on 13-4-9.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "Grid.h"
#import "NSString+Grid.h"

@interface Grid(){
    NSMutableArray * _columns;
    NSMutableArray * _dataRows;
}

@property(nonatomic,readonly) NSDateFormatter * dateFormatter;

@end

@interface GridDraw : NSObject<IGridDraw>


@end

@implementation GridDraw

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    
}

@end

@interface GridCell: GridDraw<IGridCell>

@property(nonatomic,assign) Grid * grid;

@end

@implementation GridCell

@synthesize title = _title;
@synthesize width = _width;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize backgroundColor = _backgroundColor;
@synthesize keyPath = _keyPath;
@synthesize grid = _grid;
@synthesize titleAlignment = _titleAlignment;
@synthesize titleMinFontSize = _titleMinFontSize;
@synthesize clipsLastTitle = _clipsLastTitle;
@synthesize colSpan = _colSpan;
@synthesize view;

-(id) init{
    if((self = [super init])){
        _titleAlignment = NSTextAlignmentCenter;
        _titleMinFontSize = 7;
        _colSpan = 1;
    }
    return self;
}

-(void)dealloc{
    [_title release];
    [_titleColor release];
    [_titleFont release];
    [_backgroundColor release];
    [_keyPath release];
    [view release];
    [super dealloc];
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    UIFont * font = self.titleFont;
    UIColor * textColor = self.titleColor;
    UIColor * backgroundColor = self.backgroundColor;
    
    if(font == nil){
        font = [_grid dataTitleFont];
    }
    
    if(font == nil){
        font = [UIFont systemFontOfSize:12];
    }
    
    if(textColor == nil){
        textColor = [_grid dataTitleColor];
    }
    
    if(textColor == nil){
        textColor = [UIColor blackColor];
    }
    
    UIGraphicsPushContext(ctx);

    if(backgroundColor){
        CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, backgroundColor.CGColor);
        CGContextFillRect(ctx, rect);
    }
    
    CGContextSetFillColorWithColor(ctx, textColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, textColor.CGColor);
    
    CGFloat fontSize = [font pointSize];

    NSString * title = _title;

    CGSize size = [title sizeWithFont:font minFontSize:_titleMinFontSize actualFontSize:&fontSize forWidth:rect.size.width lineBreakMode:NSLineBreakByTruncatingTail];

    if(_clipsLastTitle && fontSize != [font pointSize]){
        NSArray * ss = [_title componentsSeparatedByString:@"-"];
        title = [ss lastObject];
        fontSize = [font pointSize];
        size = [title sizeWithFont:font minFontSize:_titleMinFontSize actualFontSize:&fontSize forWidth:rect.size.width lineBreakMode:NSLineBreakByTruncatingTail];
    }
    
    CGRect textRect = CGRectMake(0, (rect.size.height - size.height) * 0.5, rect.size.width, size.height);
    
    font = [font fontWithSize:fontSize];
    
    [title drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:_titleAlignment];
    
    UIGraphicsPopContext();
    
}

@end

@interface GridColumn : GridCell<IGridColumn>

@end

@implementation GridColumn

@synthesize hidden = _hidden;

-(id<IGridCell>) newDataCell:(id) data{
    GridCell * cell = [[GridCell alloc] init];
    [cell setGrid:self.grid];

    NSString * keyPath = self.keyPath;
    
    [cell setKeyPath:keyPath];
    
    [cell setTitle:[keyPath expressionOfData:data]];
    [cell setWidth:self.width];
    [cell setClipsLastTitle:self.clipsLastTitle];
    
    return [cell autorelease];
}

@end

@interface GridRow : GridDraw<IGridRow>{
    NSMutableArray * _cells;
}

@property(nonatomic,assign) Grid * grid;

-(id) initWithGrid:(Grid *) grid data:(id) data;

@end

@implementation GridRow

@synthesize height = _height;
@synthesize cells = _cells;
@synthesize grid = _grid;
@synthesize backgroundColor = _backgroundColor;
@synthesize nextSplitColor = _nextSplitColor;

-(void) dealloc{
    [_cells release];
    [_backgroundColor release];
    [_nextSplitColor release];
    [super dealloc];
}

-(id) initWithGrid:(Grid *) grid data:(id) data{
    if((self = [super init])){
        _grid = grid;
        _cells = [[NSMutableArray alloc] initWithCapacity:4];
        for(GridColumn * column in [grid columns]){
            [_cells addObject:[column newDataCell:data]];
        }
    }
    return self;
}

-(void) applyCellViewTo:(UIView *) superview rect:(CGRect) rect{
    CGFloat splitWidth = [_grid columnSplitWidth];
    
    CGPoint p = rect.origin;

    
    for(int i=0;i<[_cells count];i++){
        
        id<IGridCell> cell = [_cells objectAtIndex:i];
        
        NSUInteger colSpan = [cell colSpan];
        
        if(splitWidth > 0.0f){
            p.x += splitWidth;
        }
        
        CGSize size = CGSizeMake([cell width], rect.size.height);
        
        while(colSpan > 1 && i +1 < [_cells count]){
            i ++;
            size.width += splitWidth + [[_cells objectAtIndex:i] width];
        }
        
        UIView * view = [cell view];
        
        if(view){
            view.frame = CGRectMake(p.x, p.y, size.width, size.height);
            [superview addSubview:view];
        }

        p.x += size.width;
    }
}

-(void) drawToContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    CGFloat splitWidth = [_grid columnSplitWidth];
    UIColor * splitColor = [_grid dataSplitColor];
    UIColor * backgroundColor = self.backgroundColor;
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }

    CGPoint p = rect.origin;

    if(backgroundColor){
        [backgroundColor setFill];
        [backgroundColor setStroke];
        CGContextFillRect(ctx, rect);
    }

    for(int i=0;i<[_cells count];i++){
        
        id<IGridCell> cell = [_cells objectAtIndex:i];
        
        NSUInteger colSpan = [cell colSpan];
        
        if(splitWidth > 0.0f){
            [splitColor setFill];
            [splitColor setStroke];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
            p.x += splitWidth;
        }
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, p.x, p.y);
        
        CGSize size = CGSizeMake([cell width], rect.size.height);
        
        while(colSpan > 1 && i +1 < [_cells count]){
            i ++;
            size.width += splitWidth + [[_cells objectAtIndex:i] width];
        }
        
        CGContextClipToRect(ctx, CGRectMake(0, 0, size.width, size.height));
        
        [cell drawToContext:ctx rect:CGRectMake(0, 0, size.width, size.height)];
        
        CGContextRestoreGState(ctx);
        
        p.x += size.width;
    }

    if(splitWidth > 0.0f){
        [splitColor setFill];
        [splitColor setStroke];
        CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
        p.x += splitWidth;
    }
}

@end



@implementation Grid

@synthesize size = _size;
@synthesize columnSplitWidth = _columnSplitWidth;
@synthesize columnSplitColor = _columnSplitColor;
@synthesize rowSplitHeight = _rowSplitHeight;
@synthesize rowSplitColor = _rowSplitColor;
@synthesize columnBackgroundColor = _columnBackgroundColor;
@synthesize columnTitleColor = _columnTitleColor;
@synthesize columnTitleFont = _columnTitleFont;
@synthesize dataTitleColor = _dataTitleColor;
@synthesize dataTitleFont = _dataTitleFont;
@synthesize dataSplitColor = _dataSplitColor;
@synthesize dateFormatter = _dateFormatter;
@synthesize limitRows = _limitRows;
@synthesize apposeLeftColumns = _apposeLeftColumns;
@synthesize apposeRightColumns = _apposeRightColumns;

-(void) dealloc{
    [_columnBackgroundColor release];
    [_dataSplitColor release];
    [_columnTitleColor release];
    [_columnTitleFont release];
    [_dataTitleColor release];
    [_dataTitleFont release];
    [_columnSplitColor release];
    [_rowSplitColor release];
    [_columns release];
    [_dataRows release];
    [_dateFormatter release];
    [super dealloc];
}

-(void) updateSize{
    
    NSInteger count = [_columns count];
    CGFloat width = 0,height = 0;
    if(count >0){
        for(id<IGridColumn> column in _columns){
            width += [column width];
        }
        width += (count + 1) * _columnSplitWidth;
    }
    
    count = [_dataRows count];
    
    if(count >0){
        NSInteger index = 0;
        for(id<IGridRow> row in _dataRows){
            if(_limitRows>0 && index >= _limitRows){
                break;
            }
            height += [row height];
            index ++;
        }
        height += (index + 1) * _rowSplitHeight;
    }
    
    _size = CGSizeMake(width, height);
}

-(NSArray *) columns{
    return _columns;
}

-(NSArray *) dataRows{
    return _dataRows;
}

-(id<IGridRow>) addDataRow:(id) data{
    GridRow * row = [[GridRow alloc] initWithGrid:self data:data];
    if(_dataRows == nil){
        _dataRows = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_dataRows addObject:row];
    return [row autorelease];
}

-(id<IGridRow>) insertDataRow:(id) data atIndex:(NSUInteger) index{
    GridRow * row = [[GridRow alloc] initWithGrid:self data:data];
    if(_dataRows == nil){
        _dataRows = [[NSMutableArray alloc] initWithCapacity:4];
    }
    [_dataRows insertObject:row atIndex:index];
    return [row autorelease];
}

-(void) removeDataRowAt:(NSUInteger) index{
    [_dataRows removeObjectAtIndex:index];
}

-(void) removeAllDataRows{
    [_dataRows removeAllObjects];
}

-(void) removeDataRow:(id<IGridRow>) row{
    [_dataRows removeObject:row];
}

-(id<IGridColumn>) addColumn{
    GridColumn * column = [[GridColumn alloc] init];
    [column setGrid:self];
    if(_columns == nil){
        _columns = [[NSMutableArray alloc] init];
    }
    [_columns addObject:column];
    return [column autorelease];
}

-(id<IGridColumn>) insertColumnAt:(NSUInteger) index{
    GridColumn * column = [[GridColumn alloc] init];
    [column setGrid:self];
    if(_columns == nil){
        _columns = [[NSMutableArray alloc] init];
    }
    [_columns insertObject:column atIndex:index];
    return [column autorelease];
}

-(void) removeColumnAt:(NSUInteger) index{
    [_columns removeObjectAtIndex:index];
}

-(void) removeColumn:(id<IGridColumn>) column{
    [_columns removeObject:column];
}

-(void) removeAllColumns{
    [_columns removeAllObjects];
}

-(void) applyCellViewTo:(UIView *) superview rect:(CGRect) rect{
    
    CGFloat splitHeight = self.rowSplitHeight;
    UIColor * splitColor = self.rowSplitColor;
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }
    
    CGPoint p = rect.origin;
    NSInteger index = 0;
    
    for(id<IGridRow> row in _dataRows){
        
        if(_limitRows>0 && index >= _limitRows){
            break;
        }
        
        if(splitHeight > 0.0f){
            p.y += splitHeight;
        }
        
        [row applyCellViewTo:superview rect:CGRectMake(p.x, p.y, rect.size.width, [row height])];
        
        p.y += [row height];
        
        index ++;
    }
    
}

-(void) drawDataToContext:(CGContextRef) ctx rect:(CGRect) rect{
    
    CGFloat splitHeight = self.rowSplitHeight;
    UIColor * splitColor = self.rowSplitColor;
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }
    
    CGPoint p = rect.origin;
    NSInteger index = 0;
    
    for(id<IGridRow> row in _dataRows){
        
        if(_limitRows>0 && index >= _limitRows){
            break;
        }
        
        if(splitHeight > 0.0f){
            [splitColor setFill];
            [splitColor setStroke];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, rect.size.width, splitHeight));
            p.y += splitHeight;
        }
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, p.x, p.y);
        
        CGContextClipToRect(ctx, CGRectMake(0, 0, rect.size.width, [row height]));
        
        [row drawToContext:ctx rect:CGRectMake(0, 0, rect.size.width, [row height])];
        
        CGContextRestoreGState(ctx);
        
        if([row nextSplitColor]){
            splitColor = [row nextSplitColor];
        }
        else{
            splitColor = self.rowSplitColor;
        }
        
        p.y += [row height];
        
        index ++;
    }
    
    if(splitHeight > 0.0f){
        [splitColor setFill];
        [splitColor setStroke];
        CGContextFillRect(ctx, CGRectMake(p.x, p.y, rect.size.width, splitHeight));
        p.y += splitHeight;
    }

}

-(void) drawHeadToContext:(CGContextRef) ctx rect:(CGRect) rect{
    
    CGFloat splitWidth = [self columnSplitWidth];
    UIColor * splitColor = [self columnSplitColor];
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }
    
    CGPoint p = rect.origin;
    
    for(id<IGridColumn> column in _columns){
       
        if(splitWidth > 0.0f){
            CGContextSetFillColorWithColor(ctx, splitColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, splitColor.CGColor);
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
            p.x += splitWidth;
        }
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, p.x, p.y);
        
        CGContextClipToRect(ctx, CGRectMake(0, 0, [column width], rect.size.height));
        
        [column drawToContext:ctx rect:CGRectMake(0, 0, [column width], rect.size.height)];
        
        CGContextRestoreGState(ctx);
        
        p.x += [column width];
    }
    
    if(splitWidth > 0.0f){
        [splitColor setFill];
        [splitColor setStroke];
        CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
        p.x += splitWidth;
    }
}

-(NSDateFormatter * )dateFormatter{
    if(_dateFormatter == nil){
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}


-(void) drawApposeHeadToContext:(CGContextRef) ctx rect:(CGRect) rect{
    CGFloat splitWidth = [self columnSplitWidth];
    UIColor * splitColor = [self columnSplitColor];
    UIColor * backgroundColor = [self columnBackgroundColor];
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }
    
    CGPoint p = rect.origin;
    
    NSInteger left = MIN(self.apposeLeftColumns,[_columns count]);
    
    for(int i=0;i<left;i++){
        
        id<IGridColumn> column = [_columns objectAtIndex:i];
        
        if(splitWidth > 0.0f){
            CGContextSetFillColorWithColor(ctx, splitColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, splitColor.CGColor);
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
            p.x += splitWidth;
        }
        
        if(backgroundColor){
            [backgroundColor setStroke];
            [backgroundColor setFill];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, [column width], rect.size.height));
        }
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, p.x, p.y);
        
        CGContextClipToRect(ctx, CGRectMake(0, 0, [column width], rect.size.height));
        
        [column drawToContext:ctx rect:CGRectMake(0, 0, [column width], rect.size.height)];
        
        CGContextRestoreGState(ctx);
        
        p.x += [column width];

    }
    
    if(splitWidth > 0.0f){
        [splitColor setFill];
        [splitColor setStroke];
        CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
        p.x += splitWidth;
    }
    
    NSInteger right = [_columns count] - MIN(self.apposeRightColumns, [_columns count]);
    
    p = rect.origin;
    p.x += p.x + rect.size.width;
    
    for(int i=[_columns count] - 1;i >= right;i--){
        
        id<IGridColumn> column = [_columns objectAtIndex:i];
        
        if(splitWidth > 0.0f){
            CGContextSetFillColorWithColor(ctx, splitColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, splitColor.CGColor);
            p.x -= splitWidth;
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
        }
        
        p.x -= [column width];
        
        if(backgroundColor){
            [backgroundColor setStroke];
            [backgroundColor setFill];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, [column width], rect.size.height));
        }
        
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, p.x, p.y);
        
        CGContextClipToRect(ctx, CGRectMake(0, 0, [column width], rect.size.height));
        
        [column drawToContext:ctx rect:CGRectMake(0, 0, [column width], rect.size.height)];
        
        CGContextRestoreGState(ctx);

    }

    if(splitWidth > 0.0f){
        [splitColor setFill];
        [splitColor setStroke];
        p.x -= splitWidth;
        CGContextFillRect(ctx, CGRectMake(p.x, p.y, splitWidth, rect.size.height));
    }
}

-(void) drawApposeDataToContext:(CGContextRef) ctx rect:(CGRect) rect{
    
    CGFloat splitWidth = [self columnSplitWidth];
    CGFloat splitHeight = self.rowSplitHeight;
    UIColor * splitColor = self.rowSplitColor;
    UIColor * dataSplitColor = [self dataSplitColor];
    
    if(splitColor == nil){
        splitColor = [UIColor grayColor];
    }
    
    CGPoint p = rect.origin;
    NSInteger index = 0;
    
    NSInteger left = MIN(self.apposeLeftColumns,[_columns count]);
    

    if(left >0){
        
        CGFloat width = (left + 1) * splitWidth;
        
        for(int i=0;i<left;i++){
            id<IGridColumn> column = [_columns objectAtIndex:i];
            width += [column width];
        }
        
        for(id<IGridRow> row in _dataRows){
            
            if(_limitRows>0 && index >= _limitRows){
                break;
            }

            if(splitHeight > 0.0f){
                [splitColor setFill];
                [splitColor setStroke];
                CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, splitHeight));
                p.y += splitHeight;
            }
            
            if(row.backgroundColor){
                [row.backgroundColor setFill];
                [row.backgroundColor setStroke];
                CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, [row height]));
            }
            
            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, p.x, p.y);
            
            CGContextClipToRect(ctx, CGRectMake(0, 0, width, [row height]));
   
            CGPoint pp = CGPointZero;
            
            NSArray * cells = [row cells];
            
            for(int i=0;i<left;i++){
                
                id<IGridCell> cell = [cells objectAtIndex:i];
                
                NSUInteger colSpan = [cell colSpan];
                
                if(splitWidth > 0.0f){
                    [dataSplitColor setFill];
                    [dataSplitColor setStroke];
                    CGContextFillRect(ctx, CGRectMake(pp.x, pp.y, splitWidth, [row height]));
                    pp.x += splitWidth;
                }
                
                CGContextSaveGState(ctx);
                
                CGContextTranslateCTM(ctx, pp.x, pp.y);
                
                CGSize size = CGSizeMake([cell width], [row height]);
                
                while(colSpan > 1 && i +1 < [cells count] && i +1 < left){
                    i ++;
                    size.width += splitWidth + [[cells objectAtIndex:i] width];
                }
                
                CGContextClipToRect(ctx, CGRectMake(0, 0, size.width, size.height));
                
                [cell drawToContext:ctx rect:CGRectMake(0, 0, size.width, size.height)];
                
                CGContextRestoreGState(ctx);
                
                pp.x += size.width;

            }
            
            if(splitWidth > 0.0f){
                [dataSplitColor setFill];
                [dataSplitColor setStroke];
                CGContextFillRect(ctx, CGRectMake(pp.x, pp.y, splitWidth, rect.size.height));
                pp.x += splitWidth;
            }

            CGContextRestoreGState(ctx);

            if([row nextSplitColor]){
                splitColor = [row nextSplitColor];
            }
            else{
                splitColor = self.rowSplitColor;
            }
            
            p.y += [row height];
        
            index ++;
        }
        
        if(splitHeight > 0.0f){
            [splitColor setFill];
            [splitColor setStroke];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, splitHeight));
            p.y += splitHeight;
        }
    }

    NSInteger right = [_columns count] - MIN(self.apposeRightColumns, [_columns count]);
    
    p = rect.origin;
    p.x += p.x + rect.size.width;
    index = 0;
    
    if(right < [_columns count]){
        
        CGFloat width = ([_columns count] - right + 1) * splitWidth;
        
        for(int i=right;i<[_columns count];i++){
            id<IGridColumn> column = [_columns objectAtIndex:i];
            width += [column width];
        }
        
        p.x -= width;
        
        for(id<IGridRow> row in _dataRows){
            
            if(_limitRows>0 && index >= _limitRows){
                break;
            }
            
            if(splitHeight > 0.0f){
                [splitColor setFill];
                [splitColor setStroke];
                CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, splitHeight));
                p.y += splitHeight;
            }
            
            if(row.backgroundColor){
                [row.backgroundColor setFill];
                [row.backgroundColor setStroke];
                CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, [row height]));
            }
            
            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, p.x, p.y);
            
            CGContextClipToRect(ctx, CGRectMake(0, 0, width, [row height]));
            
            CGPoint pp = CGPointZero;
            
            NSArray * cells = [row cells];
            
            for(int i=right;i<[_columns count];i++){
                
                id<IGridCell> cell = [cells objectAtIndex:i];
                
                NSUInteger colSpan = [cell colSpan];
                
                if(splitWidth > 0.0f){
                    [dataSplitColor setFill];
                    [dataSplitColor setStroke];
                    CGContextFillRect(ctx, CGRectMake(pp.x, pp.y, splitWidth, [row height]));
                    pp.x += splitWidth;
                }
                
                CGContextSaveGState(ctx);
                
                CGContextTranslateCTM(ctx, pp.x, pp.y);
                
                CGSize size = CGSizeMake([cell width], [row height]);
                
                while(colSpan > 1 && i +1 < [cells count] && i +1 < left){
                    i ++;
                    size.width += splitWidth + [[cells objectAtIndex:i] width];
                }
                
                CGContextClipToRect(ctx, CGRectMake(0, 0, size.width, size.height));
                
                [cell drawToContext:ctx rect:CGRectMake(0, 0, size.width, size.height)];
                
                CGContextRestoreGState(ctx);
                
                pp.x += size.width;
                
            }
            
            if(splitWidth > 0.0f){
                [dataSplitColor setFill];
                [dataSplitColor setStroke];
                CGContextFillRect(ctx, CGRectMake(pp.x, pp.y, splitWidth, rect.size.height));
                pp.x += splitWidth;
            }
            
            CGContextRestoreGState(ctx);
            
            if([row nextSplitColor]){
                splitColor = [row nextSplitColor];
            }
            else{
                splitColor = self.rowSplitColor;
            }
            
            p.y += [row height];
            
            index ++;
        }
        
        if(splitHeight > 0.0f){
            [splitColor setFill];
            [splitColor setStroke];
            CGContextFillRect(ctx, CGRectMake(p.x, p.y, width, splitHeight));
            p.y += splitHeight;
        }
    }
   
}

@end
