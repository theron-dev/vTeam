//
//  VTDOMTableElement.m
//  vTeam
//
//  Created by zhang hailong on 14-2-23.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMTableElement.h"

#import "VTDOMElement+Control.h"

@interface VTDOMTableElementCell : UITableViewCell

@property(nonatomic,retain) VTDOMElement * element;

@end

@implementation VTDOMTableElementCell

@synthesize element = _element;

-(void) dealloc{
    [_element release];
    [super dealloc];
}

-(void) setElement:(VTDOMElement *)element{
    if(_element != element){
        [element retain];
        [_element release];
        _element = element;
        
        [_element setSelected:[self isSelected]];
    }
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    [_element setSelected:selected];
}

@end


@interface VTDOMTableElement()


@property(nonatomic,retain) VTDOMStatusElement * statusElement;


@end

@implementation VTDOMTableElement

@synthesize statusElement = _statusElement;

-(void) dealloc{
    
    if([self isViewLoaded]){
        [[self tableView] setDelegate:nil];
        [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [_statusElement release];

    [super dealloc];
}

-(void) render:(CGRect) rect context:(CGContextRef) context{
    
}

-(UITableView *) tableView{
    return (UITableView *) self.view;
}

-(Class) viewClass{
    NSString * view = [self stringValueForKey:@"viewClass"];
    Class clazz = NSClassFromString(view);
    if(clazz == nil || ![clazz isSubclassOfClass:[UITableView class]]){
        clazz = [UITableView class];
    }
    return clazz;
}

-(void) setView:(UIView *)view{
    
    [self.tableView setDelegate:nil];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    
    [super setView:view];
    
    [self.tableView setContentInset:[self edgeInsetsValueForKey:@"content-inset"]];
    [self.tableView setScrollIndicatorInsets:[self edgeInsetsValueForKey:@"scroll-inset"]];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addObserver:self forKeyPath:@"contentOffset"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:[self booleanValueForKey:@"allowsSelection"]];
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    if([self isViewLoaded] && delegate){
        [[self tableView] reloadData];
    }
}


-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    
    CGSize size = self.frame.size;
    
    CGSize contentSize = CGSizeMake(size.width, 0);
    
    for (VTDOMElement * element in [self childs]) {
        
        [element layout:size];
        
        CGRect r = element.frame;
        UIEdgeInsets margin = [element margin];
        
        r.origin = CGPointMake(padding.left + margin.left, contentSize.height + margin.top);
        r.size.width = size.width - padding.left - padding.right - margin.left - margin.right;
        
        [element setFrame:r];
        
        contentSize.height += r.size.height + margin.top + margin.bottom;
    }
    
    if(contentSize.height < size.height){
        contentSize.height = size.height;
    }
    
    [self setContentSize:contentSize];
    
    return size;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self childs] count];
}

-(VTDOMElement *) elementByIndexPath:(NSIndexPath *) indexPath{
    NSArray * childs = [self childs];
    if(indexPath.row < [childs count]){
        return [childs objectAtIndex:indexPath.row];
    }
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element = [self elementByIndexPath:indexPath];
    
    CGRect r = [element frame];
    UIEdgeInsets margin = [element margin];
    
    return r.size.height + margin.top + margin.bottom;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element = [self elementByIndexPath:indexPath];
    
    NSString * editable = [element attributeValueForKey:@"editable"];
    
    if([editable isEqualToString:@"delete"]){
        return YES;
    }
    
    return NO;
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element = [self elementByIndexPath:indexPath];
    
    NSString * editable = [element attributeValueForKey:@"editable"];
    
    if([editable isEqualToString:@"delete"]){
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element  = [self elementByIndexPath:indexPath];
    
    NSString * reuseIdentifier = [element attributeValueForKey:@"reuse"];
    
    if(reuseIdentifier == nil){
        reuseIdentifier = @"";
    }
    
    VTDOMTableElementCell * cell = (VTDOMTableElementCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(cell == nil){
        
        cell = [[[VTDOMTableElementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        VTDOMView * view = [[VTDOMView alloc] initWithFrame:cell.bounds];
        
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:100];
        
        [cell.contentView addSubview:view];
        
        [view release];
        
    }
    
    VTDOMView * domView = self.delegate;
    
    if(![domView isKindOfClass:[VTDOMView class]]){
        domView = nil;
    }
    
    VTDOMView * view = (VTDOMView *) [cell.contentView viewWithTag:100];
    
    view.delegate = domView.delegate;
    
    CGRect r = [element frame];
    UIEdgeInsets margin = [element margin];
    UIEdgeInsets padding = [self padding];
    
    [view setFrame:CGRectMake(padding.left + margin.left, margin.top, r.size.width, r.size.height)];
    
    [cell setElement:element];
    
    if(view.element != element){
    
        [view setUserInteractionEnabled:! [element booleanValueForKey:@"disabled"]];
        
        [view setElement:element];
        
        if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForElement:)]){
            [[domView delegate] vtDOMView:domView downloadImagesForElement:element];
        }
        
        if([[domView delegate] respondsToSelector:@selector(vtDOMView:downloadImagesForView:)]){
            [[domView delegate] vtDOMView:domView downloadImagesForView:view];
        }
        
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element = [self elementByIndexPath:indexPath];
    
    [element retain];
    [element setAttributeValue:@"commitEditing" forKey:@"event"];
    
    if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
        [self.delegate vtDOMElementDoAction:element];
    }
    
    [element setAttributeValue:nil forKey:@"event"];
    [element release];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VTDOMElement * element = [self elementByIndexPath:indexPath];
    
    [element retain];
    [element setAttributeValue:@"didSelect" forKey:@"event"];
    
    if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
        [self.delegate vtDOMElementDoAction:element];
    }
    
    [element setAttributeValue:nil forKey:@"event"];
    [element release];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([self isViewLoaded] && self.tableView == object
       && [keyPath isEqualToString:@"contentOffset"]){
        
        UITableView * tableView = [self tableView];
        
        CGPoint contentOffset = tableView.contentOffset;
        CGSize size = tableView.bounds.size;
        UIEdgeInsets contentInset = tableView.contentInset;
        CGPoint bottomOffset = CGPointMake(contentOffset.x + size.width - contentInset.left - contentInset.right, contentOffset.y + size.height - contentInset.top - contentInset.bottom);
        
        for(NSIndexPath * indexPath in [tableView indexPathsForVisibleRows]){
            
            VTDOMElement * element = [self elementByIndexPath:indexPath];
            
            CGRect r = [element frame];
            
            if([element isKindOfClass:[VTDOMStatusElement class]]
               && ![[(VTDOMStatusElement *) element status] isEqualToString:@"loading"]){
                
                NSString * target = [element attributeValueForKey:@"target"];
                
                if(r.origin.y < 0 && contentOffset.y < 0 && [target isEqualToString:@"top"]){
                    if(r.origin.y - contentOffset.y >= 0){
                        [(VTDOMStatusElement *) element setStatus:@"topover"];
                    }
                    else{
                        [(VTDOMStatusElement *) element setStatus:@"top"];
                    }
                    self.statusElement = (VTDOMStatusElement *) element;
                }
                else if(bottomOffset.y > r.origin.y && [target isEqualToString:@"bottom"]){
                    if(bottomOffset.y >= r.origin.y + r.size.height){
                        [(VTDOMStatusElement *) element setStatus:@"bottomover"];
                    }
                    else{
                        [(VTDOMStatusElement *) element setStatus:@"bottom"];
                    }
                    self.statusElement = (VTDOMStatusElement *) element;
                }
                else if(bottomOffset.x > r.origin.x && [target isEqualToString:@"right"]){
                    if(bottomOffset.x >= r.origin.x + r.size.width){
                        [(VTDOMStatusElement *) element setStatus:@"rightover"];
                    }
                    else{
                        [(VTDOMStatusElement *) element setStatus:@"right"];
                    }
                    self.statusElement = (VTDOMStatusElement *) element;
                }
                else if(r.origin.x < 0 && contentOffset.x < 0 && [target isEqualToString:@"left"]){
                    if(r.origin.x - contentOffset.x >= 0){
                        [(VTDOMStatusElement *) element setStatus:@"leftover"];
                    }
                    else{
                        [(VTDOMStatusElement *) element setStatus:@"left"];
                    }
                    self.statusElement = (VTDOMStatusElement *) element;
                }
                else{
                    [(VTDOMStatusElement *) element setStatus:nil];
                }
                
            }
            
        }
        
    }
    
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_statusElement){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:_statusElement];
        }
        
        self.statusElement = nil;
    }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if(_statusElement){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:_statusElement];
        }
        
        self.statusElement = nil;
    }
    
}


@end
