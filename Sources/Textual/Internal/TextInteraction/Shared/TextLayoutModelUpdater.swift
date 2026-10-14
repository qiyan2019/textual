#if TEXTUAL_ENABLE_TEXT_SELECTION
  import SwiftUI

  // 通过平台视图更新传递最终布局，避免 onChange 在同一帧内丢弃后续布局通知。
  // 辅助视图不参与命中测试，选择、链接和代码块滚动仍由原交互层处理。
  #if canImport(UIKit)
    struct TextLayoutModelUpdater: UIViewRepresentable {
      let model: TextSelectionModel
      let layoutCollection: any TextLayoutCollection
      let coordinator: TextSelectionCoordinator?

      func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
      }

      func updateUIView(_ uiView: UIView, context: Context) {
        model.setCoordinator(coordinator)
        model.setLayoutCollection(layoutCollection)
      }
    }
  #elseif canImport(AppKit)
    struct TextLayoutModelUpdater: NSViewRepresentable {
      let model: TextSelectionModel
      let layoutCollection: any TextLayoutCollection
      let coordinator: TextSelectionCoordinator?

      func makeNSView(context: Context) -> LayoutUpdateView {
        LayoutUpdateView()
      }

      func updateNSView(_ nsView: LayoutUpdateView, context: Context) {
        model.setCoordinator(coordinator)
        model.setLayoutCollection(layoutCollection)
      }

      final class LayoutUpdateView: NSView {
        override func hitTest(_ point: NSPoint) -> NSView? { nil }
      }
    }
  #endif
#endif
