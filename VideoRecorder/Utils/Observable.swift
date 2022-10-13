//
//  Observable.swift
//  VideoRecorder
//
//  Created by channy on 2022/10/11.
//

class Observable<T> {
    var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
