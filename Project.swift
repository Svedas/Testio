import ProjectDescription

let target = Target.target(
    name: "Testio",
    destinations: [.iPhone],
    product: .app,
    bundleId: "com.svedas.nordsec.testio",
    deploymentTargets: .iOS("16.6"),
    infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": .string("FakeStoryboardForFullScreenBug"),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([
                "UIWindowSceneSessionRoleApplication": .array([
                    .dictionary([
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ])
                ])
            ])
        ]),
        "CFBundlePackageType": .string("$(PRODUCT_BUNDLE_PACKAGE_TYPE)")
    ]),
    sources: ["Source/**"],
    resources: ["Resources/**"],
    scripts: [
        .pre(
            path: "./Scripts/swiftlint.sh",
            name: "Run swiftlint.",
            basedOnDependencyAnalysis: false
        )
    ],
    dependencies: [
        .external(name: "Alamofire"),
        .external(name: "KeychainAccess"),
        .external(name: "Swinject")
    ]
)

let unitTestsTarget = Target.target(
    name: "UnitTests",
    destinations: [.iPhone],
    product: .unitTests,
    bundleId: "com.svedas.nordsec.testioUnitTests",
    deploymentTargets: .iOS("16.6"),
    infoPlist: .default,
    sources: ["UnitTests/**"],
    dependencies: [
        .target(name: "Testio")
    ]
)

let uiTestsTarget = Target.target(
    name: "UITests",
    destinations: [.iPhone],
    product: .uiTests,
    bundleId: "com.svedas.nordsec.testioUITests",
    deploymentTargets: .iOS("16.6"),
    infoPlist: .default,
    sources: ["UITests/**"],
    dependencies: [
        .target(name: "Testio")
    ]
)

let scheme = Scheme.scheme(
    name: "Testio",
    buildAction: .buildAction(
        targets: [
            .init(stringLiteral: "Testio"),
            .init(stringLiteral: "UnitTests"),
            .init(stringLiteral: "UITests")
        ]
    )
)

let project = Project(
    name: "Testio",
    organizationName: "Svedas",
    targets: [target, unitTestsTarget, uiTestsTarget],
    schemes: [scheme],
    additionalFiles: [
        "Project.swift",
        "Package.swift",
        ".swiftlint.yml",
        ".swiftlint.autocorrect.yml"
    ]
)
