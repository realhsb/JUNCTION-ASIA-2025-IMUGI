//
//  VerticalDualButton.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import SwiftUI
import UIKit

/// 세로 2분할 액션 버튼 (위/아래 각각 탭 가능)
struct VerticalDualButton: View {
    var topSystemImage: String
    var bottomSystemImage: String
    var onTopTap: () -> Void
    var onBottomTap: () -> Void

    // 스타일 커스터마이즈
    var width: CGFloat = 52
    var cornerRadius: CGFloat = 12

    var body: some View {
        VStack(spacing: 0) {
            // 상단 버튼
            Button(action: { onTopTap() }) {
                symbol(topSystemImage)
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.plain)

            // 구분선
            Rectangle()
                .fill(.white.opacity(0.45))
                .frame(height: 1)
                .padding(.horizontal, 12)

            // 하단 버튼
            Button(action: { onBottomTap() }) {
                symbol(bottomSystemImage)
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.gray01)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(.gray01)
        )
        .shadow(radius: 6)
    }

    @ViewBuilder
    private func symbol(_ name: String) -> some View {
        Image(systemName: name)
            .symbolRenderingMode(.monochrome)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.white)
            .frame(height: 2)
            .contentShape(Rectangle()) // 탭 영역 확보
    }
}

