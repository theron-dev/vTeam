//
//  VTPillarChart.m
//  vTeam
//
//  Created by zhang hailong on 14-1-9.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTPillarChart.h"

#import "VTChartRectangle.h"
#import "VTChartLabel.h"

@implementation VTPillarChart

-(void) dealloc{
    [_titleReader release];
    [_valueReader release];
    [_dataItemsReader release];
    [_colorReader release];
    [_borderColorReader release];
    [_font release];
    [_titleColor release];
    [_lineColor release];
    [super dealloc];
}

-(void) reloadData{
    
    [self removeAllComponents];
    
    NSArray * dataItems = [_dataItemsReader dataItemsValue:self.dataSource];
    
    double minValue = 0;
    double maxValue = 0;
    int count = 0;
    
    for(id dataItem in dataItems){
        
        double v = [_valueReader doubleValue:dataItem];
        
        if(count == 0){
            minValue = maxValue = v;
        }
        else{
            if(v > maxValue){
                maxValue = v;
            }
            
            if(v < minValue){
                minValue = v;
            }
        }
        
        count ++;
    }
    
    if(minValue > 0.0){
        minValue = 0.0;
    }
    
    if(maxValue < 0.0){
        maxValue = 0.0;
    }
    
    double dValue = maxValue - minValue;
    
    if(dValue != 0.0){

        CGSize size = self.size;
        UIEdgeInsets padding = self.padding;
        
        CGSize innerSize = CGSizeMake(size.width - padding.left - padding.right
                                      , size.height - padding.top - padding.bottom - _font.pointSize * 2.0);
        
        CGFloat itemWidth = innerSize.width / (count * 2 + 1);
        
        CGFloat cTop = padding.top + _font.pointSize + (1.0 - (0.0 - minValue)  / dValue) * innerSize.height - _lineWidth / 2.0;
        
        int index = 0;
        
        for(id dataItem in dataItems){
            
            double v = [_valueReader doubleValue:dataItem];
            
            VTChartRectangle * rectangle = [[VTChartRectangle alloc] init];
            
            rectangle.borderWidth = _borderWidth;
            rectangle.borderColor = [_borderColorReader colorValue:dataItem];
            rectangle.backgroundColor = [_colorReader colorValue:dataItem];
            
            if(v >= 0){
                
                CGFloat height= v * innerSize.height / dValue;
                
                if(height < _minHeight){
                    height = _minHeight;
                }
                
                rectangle.size = CGSizeMake(itemWidth ,height );
                rectangle.anchor = CGPointMake(0.0, 1.0);
                rectangle.position = CGPointMake(_padding.left + (index * 2.0 + 1) * itemWidth, cTop - _lineWidth / 2.0);
            }
            else{
                
                CGFloat height= - v * innerSize.height / dValue;
                
                if(height < _minHeight){
                    height = _minHeight;
                }
                
                rectangle.size = CGSizeMake(itemWidth, height );
                rectangle.anchor = CGPointMake(0.0, 0.0);
                rectangle.position = CGPointMake(_padding.left +(index * 2.0 + 1) * itemWidth, cTop + _lineWidth / 2.0 );
            }
            
            
            [self addComponent:rectangle];
            
            
            
            NSString * title = [_titleReader stringValue:dataItem];
            
            if(title){
                
                VTChartLabel * label = [[VTChartLabel alloc] init];
                
                [label setTitle:title];
                [label setTitleColor:_titleColor];
                [label setFont:_font];
                
                [label sizeToFit];
                
                if(v >=0){
                    label.anchor = CGPointMake(0.5, 1.0);
                    label.position = CGPointMake(_padding.left +(index * 2.0 + 1.5) * itemWidth,cTop - _lineWidth / 2.0 - rectangle.size.height);
                }
                else{
                    label.anchor = CGPointMake(0.5, 0.0);
                    label.position = CGPointMake(_padding.left +(index * 2.0 + 1.5) * itemWidth,cTop + _lineWidth / 2.0 + rectangle.size.height);
                }
                
                [self addComponent:label];
                
                [label release];
                
            }
            
            [rectangle release];

            
            index ++;
        }
        
        VTChartRectangle * rectangle = [[VTChartRectangle alloc] init];
        
        rectangle.backgroundColor = _lineColor;
        rectangle.size = CGSizeMake(innerSize.width, _lineWidth);
        rectangle.anchor = CGPointMake(0.5, 0);
        rectangle.position = CGPointMake(size.width / 2.0, cTop );
        
        [self addComponent:rectangle];
        
        [rectangle release];

    }
}

@end
