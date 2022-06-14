
import XCTest
@testable import BraveSwiftDIP

#if os(macOS)
fileprivate typealias NSUIImage = NSImage
#elseif os(iOS)
fileprivate typealias NSUIImage = UIImage
#endif

final class BraveSwiftDIPTests: XCTestCase {
    fileprivate let dog = BraveSwiftDIPTests.nsuiImage(filename: "dog.jpeg")
    fileprivate let dog2 = BraveSwiftDIPTests.nsuiImage(filename: "dog2.jpeg")
    fileprivate let cat = BraveSwiftDIPTests.nsuiImage(filename: "cat.png")
    
    fileprivate static func nsuiImage(filename: String) -> NSUIImage? {
        #if os(macOS)
        let url = Bundle.module.urlForImageResource(NSImage.Name(filename))
        
        guard let url = url else {
            return nil
        }
        
        return NSImage(byReferencing: url)
        #elseif os(iOS)
        let url = Bundle.module.url(forResource: filename, withExtension: nil)
        
        guard let url = url, let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return UIImage(data: data)
        #endif
    }
    
    func testNSImageDiff() throws {
        XCTAssertTrue(NSUIImage.diffCompare(image: dog, with: dog))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: dog2))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: cat))
    }
    
    func testNSUIImageCGImageConvertion() throws {
        #if os(macOS)
        XCTAssertTrue(NSUIImage.diffCompare(image: dog, with: dog?.cgImage?.nsImage))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: dog2?.cgImage?.nsImage))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: cat?.cgImage?.nsImage))
        #elseif os(iOS)
        XCTAssertTrue(NSUIImage.diffCompare(image: dog, with: dog?.cgImage?.uiImage))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: dog2?.cgImage?.uiImage))
        XCTAssertFalse(NSUIImage.diffCompare(image: dog, with: cat?.cgImage?.uiImage))
        #endif
    }
    
    func testNSImageCIImageConvertion() throws {
        // TODO: Check how to make the comparation.
    }
}
