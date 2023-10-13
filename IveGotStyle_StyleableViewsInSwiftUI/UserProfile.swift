//
//  UserProfile.swift
//  MilesOfStyle
//
//  Created by Richard Turton on 29/08/2023.
//

import SwiftUI

struct UserProfile<Picture: View, Badge: View>: View {

    @Environment(\.userProfileStyle) private var style
    let configuration: UserProfileStyleConfiguration
    init(_ name: String, @ViewBuilder picture: () -> Picture, @ViewBuilder badge: () -> Badge) {
        configuration = .init(picture: .init(picture()), badge: .init(badge()), name: name)
    }

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))

    }
}

struct UserProfile_Previews: PreviewProvider {


    static var previews: some View {
        Container()
    }
}

struct Container: View {
    var profile: some View {
        UserProfile("Richard") {
            Image("profile").resizable()
        } badge: {
            Image(systemName: "sun.max.fill")
                .symbolRenderingMode(.multicolor)
        }
    }
    var chrisProfile: some View {
        UserProfile("Chris") {
            Image("chris").resizable()
        } badge: {
            Image(systemName: "cloud.heavyrain")
                .symbolRenderingMode(.multicolor)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: -20) {
                    profile
                        .zIndex(1)
                    chrisProfile
                }
                .playerProfileStyle(.hero)
                Divider()
                VStack(alignment: .leading) {
                    profile
                    Text("Don't put me on last this time, it's too much pressure")
                    Divider()
                    chrisProfile
                    Text("OK I pinky promise")
                }
                .playerProfileStyle(.chat)
                .padding()
                Spacer()
            }
            .navigationTitle("Secret Chat")
        }
    }
}

protocol UserProfileStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = UserProfileStyleConfiguration
}

struct UserProfileStyleConfiguration {
    let picture: AnyView
    let badge: AnyView
    let name: String
}

struct UserProfileStyleKey: EnvironmentKey {
    static let defaultValue:
      any UserProfileStyle = HeroUserProfileStyle()
}

extension EnvironmentValues {
    var userProfileStyle: any UserProfileStyle {
        get { self[UserProfileStyleKey.self] }
        set { self[UserProfileStyleKey.self] = newValue }
    }
}

extension View {
    func playerProfileStyle(_ style: any UserProfileStyle) -> some View {
        self.environment(\.userProfileStyle, style)
    }
}

struct HeroUserProfileStyle: UserProfileStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.picture
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke()
            }
            .overlay(alignment: .topTrailing) {
                configuration.badge
                    .font(.headline)
                    .padding()
                    .background(in: Circle())
                    .overlay { Circle().stroke() }
            }
            .padding(.bottom)
            .overlay(alignment: .bottom) {
                Text(configuration.name)
                    .padding(5)
                    .background(in: RoundedRectangle(cornerRadius: 5))
                    .overlay { RoundedRectangle(cornerRadius: 5).stroke()}
            }
    }
}

struct ChatAvatarUserProfileStyle: UserProfileStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.picture
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke()
                }
            VStack(alignment: .leading) {
                configuration.badge
                Text(configuration.name)
                    .font(.caption)
            }
        }
    }
}

extension UserProfileStyle where Self == HeroUserProfileStyle {
    static var hero: Self { HeroUserProfileStyle() }
}

extension UserProfileStyle where Self == ChatAvatarUserProfileStyle {
    static var chat: Self { ChatAvatarUserProfileStyle() }
}
