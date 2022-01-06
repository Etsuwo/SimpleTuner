//
//  Note.swift
//  guitarTuner
//
//  Created by 大谷悦志 on 2019/04/10.
//  Copyright © 2019 大谷悦志. All rights reserved.
//

import Foundation

enum Accidental: String {
    case Sharp = "♯"
    case Flat = "♭"
}

    //CustomStringConvertibleはprintを許す型？みたいな？
enum Note: CustomStringConvertible {
    case c(_: Accidental?)
    case d(_: Accidental?)
    case e(_: Accidental?)
    case f(_: Accidental?)
    case g(_: Accidental?)
    case a(_: Accidental?)
    case b(_: Accidental?)
    
    //12個の音階の名前をつけた配列
    static let all: [Note] = [
        c(nil),   c(.Sharp),
        d(nil),
        e(.Flat), e(nil),
        f(nil),   f(.Sharp),
        g(nil),
        a(.Flat), a(nil),
        b(.Flat), b(nil)
    ]
    
    //周波数の計算をPItchクラスでさせるためにこちらではIndexまでを計算。基準周波数を変えれるようにしたい
    var index: Int {
        let index = Note.all.index(where: { $0 == self})! - Note.all.index(where: { $0 == Note.a(nil)})!
        return index
    }
    //$0は内部引数名を省略した時に使うやつ、だけど、そもそもこの場合引数とは。。。多分
    //使ってないナウ
    /*var frequency: Double {
        let index = Note.all.index(where: { $0 == self})! - Note.all.index(where: { $0 == Note.a(nil)})!
        
        return 440 * pow(2, Double(index) / 12.0)
    }*/
    
    var description: String {
        let concat = { (letter: String, accidental: Accidental?) in
            return letter + (accidental != nil ? accidental!.rawValue : "")
        }
        
        switch self {
        case let .c(a): return concat("C", a)
        case let .d(a): return concat("D", a)
        case let .e(a): return concat("E", a)
        case let .f(a): return concat("F", a)
        case let .g(a): return concat("G", a)
        case let .a(a): return concat("A", a)
        case let .b(a): return concat("B", a)
        }
    }

    
}

func ==(a:Note, b:Note) -> Bool {
    return a.description == b.description
}
