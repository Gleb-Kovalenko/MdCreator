//
//  Dictionary.swift
//  
//
//  Created by Gleb Kovalenko on 27.08.2022.
//

import Foundation

// MARK: - Dictionary

extension Dictionary where Key == String, Value: Any {
    
    @discardableResult func jsonMap<T1>(
        _ type1: T1.Type,
        _ func1: (_ Element: T1) throws -> T1 = { $0 }
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let t1TypeValue = dataValue as? T1 {
                result[dataKey] = try func1(t1TypeValue)
            } else {
                result[dataKey] = dataValue
            }
        }
        return result
    }
    
    @discardableResult func jsonMap<T1, T2>(
    _ type1: T1.Type,
    _ func1: (_ Element: T1) throws -> T1 = { $0 },
    _ type2: T2.Type,
    _ func2: (_ Element: T2) throws -> T2 = { $0 }
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let t1TypeValue = dataValue as? T1 {
                result[dataKey] = try func1(t1TypeValue)
            } else if let t2TypeValue = dataValue as? T2 {
                result[dataKey] = try func2(t2TypeValue)
            } else {
                result[dataKey] = dataValue
            }
        }
        return result
    }
    
    @discardableResult func jsonMap<T1, T2, T3>(
    _ type1: T1.Type,
    _ func1: (_ Element: T1) throws -> T1 = { $0 },
    _ type2: T2.Type,
    _ func2: (_ Element: T2) throws -> T2 = { $0 },
    _ type3: T3.Type,
    _ func3: (_ Element: T3) throws -> T3 = { $0 }
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let t1TypeValue = dataValue as? T1 {
                result[dataKey] = try func1(t1TypeValue)
            } else if let t2TypeValue = dataValue as? T2 {
                result[dataKey] = try func2(t2TypeValue)
            } else if let t3TypeValue = dataValue as? T3 {
                result[dataKey] = try func3(t3TypeValue)
            } else {
                result[dataKey] = dataValue
            }
        }
        return result
    }
    
    @discardableResult func jsonMap<T1,T2, T3, T4>(
    _ type1: T1.Type,
    _ func1: (_ Element: T1) throws -> T1 = { $0 },
    _ type2: T2.Type,
    _ func2: (_ Element: T2) throws -> T2 = { $0 },
    _ type3: T3.Type,
    _ func3: (_ Element: T3) throws -> T3 = { $0 },
    _ type4: T4.Type,
    _ func4: (_ Element: T4) throws -> T4 = { $0 }
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let t1TypeValue = dataValue as? T1 {
                result[dataKey] = try func1(t1TypeValue)
            } else if let t2TypeValue = dataValue as? T2 {
                result[dataKey] = try func2(t2TypeValue)
            } else if let t3TypeValue = dataValue as? T3 {
                result[dataKey] = try func3(t3TypeValue)
            } else if let t4TypeValue = dataValue as? T4 {
                result[dataKey] = try func4(t4TypeValue)
            } else {
                result[dataKey] = dataValue
            }
        }
        return result
    }
    
    @discardableResult func jsonMap<T1,T2, T3, T4, T5>(
    _ type1: T1.Type,
    _ func1: (_ Element: T1) throws -> T1 = { $0 },
    _ type2: T2.Type,
    _ func2: (_ Element: T2) throws -> T2 = { $0 },
    _ type3: T3.Type,
    _ func3: (_ Element: T3) throws -> T3 = { $0 },
    _ type4: T4.Type,
    _ func4: (_ Element: T4) throws -> T4 = { $0 },
    _ type5: T5.Type,
    _ func5: (_ Element: T5) throws -> T5 = { $0 }
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let t1TypeValue = dataValue as? T1 {
                result[dataKey] = try func1(t1TypeValue)
            } else if let t2TypeValue = dataValue as? T2 {
                result[dataKey] = try func2(t2TypeValue)
            } else if let t3TypeValue = dataValue as? T3 {
                result[dataKey] = try func3(t3TypeValue)
            } else if let t4TypeValue = dataValue as? T4 {
                result[dataKey] = try func4(t4TypeValue)
            } else if let t5TypeValue = dataValue as? T5 {
                result[dataKey] = try func5(t5TypeValue)
            } else {
                result[dataKey] = dataValue
            }
        }
        return result
    }
}
