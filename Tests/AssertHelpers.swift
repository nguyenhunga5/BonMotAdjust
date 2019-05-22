//
//  AssertHelpers.swift
//  BonMot
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

func dataFromImage(image theImage: BONImage) -> Data {
    assert(theImage.size != .zero)
    #if os(OSX)
        let cgImageRef = theImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImageRef!)
        let pngData = bitmapImageRep.representation(using: .PNG, properties: [:])!
        return pngData
    #else
        return theImage.pngData()!
    #endif
}

func BONAssert<T: Equatable>(attributes dictionary: StyleAttributes?, key: String, value: T, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssert(dictionaryValue == value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
}

func BONAssertColor(inAttributes dictionary: StyleAttributes?, key: String, color controlColor: BONColor, file: StaticString = #file, line: UInt = #line) {
    guard let testColor = dictionary?[key] as? BONColor else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }

    let testComps = testColor.rgbaComponents
    let controlComps = controlColor.rgbaComponents

    XCTAssertEqualWithAccuracy(testComps.r, controlComps.r, accuracy: 0.0001)
    XCTAssertEqualWithAccuracy(testComps.g, controlComps.g, accuracy: 0.0001)
    XCTAssertEqualWithAccuracy(testComps.b, controlComps.b, accuracy: 0.0001)
    XCTAssertEqualWithAccuracy(testComps.a, controlComps.a, accuracy: 0.0001)
}

func BONAssert(attributes dictionary: StyleAttributes?, key: String, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? CGFloat else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqualWithAccuracy(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (BONFont) -> CGFloat, float: CGFloat, accuracy: CGFloat = 0.001, file: StaticString = #file, line: UInt = #line) {
    guard let font = dictionary?[convertFromNSAttributedStringKey(NSAttributedString.Key.font)] as? BONFont else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let value = query(font)
    XCTAssertEqualWithAccuracy(value, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> CGFloat, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle)] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqualWithAccuracy(actualValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> Int, value: Int, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle)] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value, actualValue, file: file, line: line)
}

#if swift(>=3.0)
    func BONAssert<T: RawRepresentable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) where T.RawValue: Equatable {
        guard let paragraphStyle = dictionary?[convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle)] as? NSParagraphStyle else {
            XCTFail("value is not of expected type", file: file, line: line)
            return
        }
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value.rawValue, actualValue.rawValue, file: file, line: line)
    }

    func BONAssertEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertEqual(data1, data2, file: file, line: line)
    }

    func BONAssertNotEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertNotEqual(data1, data2, file: file, line: line)
    }

    func BONAssertEqualFonts(_ font1: BONFont, _ font2: BONFont, file: StaticString = #file, line: UInt = #line) {
        let descriptor1 = font1.fontDescriptor
        let descriptor2 = font2.fontDescriptor

        XCTAssertEqual(descriptor1, descriptor2, file: file, line: line)
    }
#else
    func BONAssert<T: RawRepresentable where T.RawValue: Equatable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) {
        guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            XCTFail("value is not of expected type", file: file, line: line)
            return
        }
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value.rawValue, actualValue.rawValue, file: file, line: line)
    }

    func BONAssertEqualImages(image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertEqual(data1, data2, file: file, line: line)
    }

    func BONAssertNotEqualImages(image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertNotEqual(data1, data2, file: file, line: line)
    }

    func BONAssertEqualFonts(font1: BONFont, _ font2: BONFont, file: StaticString = #file, line: UInt = #line) {
        let descriptor1 = font1.fontDescriptor
        let descriptor2 = font2.fontDescriptor

        XCTAssertEqual(descriptor1, descriptor2, file: file, line: line)
    }
#endif

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
