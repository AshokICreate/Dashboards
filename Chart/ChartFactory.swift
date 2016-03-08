//
//  GraphFactory.swift
//  Chart
//
//  Created by Phani on 17/11/15.
//  Copyright © 2015 MetricStream. All rights reserved.
//

import UIKit

protocol ChartFactoryProtocol {
    func createGraph(graph:ChartTypesEnum) -> (DisplayView)
}

enum ChartTypesEnum {
    case Line
    case Column
    case Bar
    case StackedColumn
}

class ChartFactory: ChartFactoryProtocol {
    
    static let instance = ChartFactory()
    
    func createGraph(graph:ChartTypesEnum) -> (DisplayView)
    {
        switch graph
        {
            case .Column:
             return ColumnDisplayView.init(frame: CGRectZero);
            
            case .StackedColumn:
            return StackedColumnDisplayView.init(frame: CGRectZero);
            
            default:
             return LinesDisplayView.init(frame: CGRectZero);
        }
    }
}
