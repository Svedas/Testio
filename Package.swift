// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework,
            "KeychainAccess": .framework,
            "Swinject": .framework
        ]
    )
#endif

let package = Package(
    name: "Testio",
    dependencies: [
         .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
         .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "3.0.0"),
         .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMinor(from: "2.8.0"))
    ]
)
