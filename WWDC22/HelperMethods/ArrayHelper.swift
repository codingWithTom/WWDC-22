//
//  ArrayHelper.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-09-19.
//

import Foundation

extension Array {
  func groupBy<K>(keyPath: KeyPath<Element, K>) -> [K: [Element]] {
    var dictionary: [K: [Element]] = [:]
    for element in self {
      let key = element[keyPath: keyPath]
      var elements = dictionary[key] ?? []
      elements.append(element)
      dictionary[key] = elements
    }
    return dictionary
  }
  
  func groupBy<K>(_ getKey: (Element) -> K) -> [K: [Element]] {
    var dictionary: [K: [Element]] = [:]
    for element in self {
      let key = getKey(element)
      var elements = dictionary[key] ?? []
      elements.append(element)
      dictionary[key] = elements
    }
    return dictionary
  }
}
