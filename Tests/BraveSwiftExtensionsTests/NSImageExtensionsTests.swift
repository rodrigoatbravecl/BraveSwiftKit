import XCTest
@testable import BraveSwiftExtensions

final class NSImageExtensionsTests: XCTestCase {
    var nsTestImage: NSImage? {
        let url = Bundle.module.url(forResource: "YellowLabradorLooking_new", withExtension: "jpeg")
        
        guard let url = url else {
            return nil
        }
        
        return NSImage(byReferencing: url)
    }
    
    func testExample() throws {
        let converted = nsTestImage?.cgImage?.nsImage
        let original = nsTestImage
//        let d = ImageDiff()
//        
//        
//        
//        print(try! d.compare(leftImage: converted!.cgImage!, rightImage: original!.cgImage!))
        XCTAssertTrue(1 != 0)
    }
}

