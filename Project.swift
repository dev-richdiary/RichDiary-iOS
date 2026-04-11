import ProjectDescription

let project = Project(
    name: "RichDiary",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "586LZSS32L",
            "MARKETING_VERSION": "1.0.0",
            "CURRENT_PROJECT_VERSION": "1",
        ],
        debug: [:],
        release: [:],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "RichDiary",
            destinations: [.iPhone],
            product: .app,
            productName: "RichDiary",
            bundleId: "io.tuist.RichDiary",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "CFBundleIconName": "AppIcon",
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                    "CFBundleDisplayName": "부자가계부",
                    "UIAppFonts": [
                        "Pretendard-Bold.otf",
                        "Pretendard-Medium.otf",
                        "Pretendard-Regular.otf",
                        "Pretendard-SemiBold.otf"
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                ]
            ),
            sources: ["RichDiary/Sources/**"],
            resources: ["RichDiary/Resources/**"],
            dependencies: [
                .external(name: "SnapKit", condition: .none),
                .external(name: "Then", condition: .none),
                .external(name: "RxSwift", condition: .none),
                .external(name: "RxCocoa", condition: .none),
                .external(name: "RxRelay", condition: .none),
                .external(name: "RealmSwift", condition: .none),
                .external(name: "Realm", condition: .none)
            ]
        ),
        .target(
            name: "RichDiaryTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "io.tuist.RichDiaryTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["RichDiaryTests/**"],
            resources: [],
            dependencies: [
                .target(name: "RichDiary"),
                .external(name: "RxSwift"),
                .external(name: "RxTest"),
                .external(name: "RxBlocking"),
            ]
        ),
    ]
)
