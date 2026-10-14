#if TEXTUAL_ENABLE_TEXT_SELECTION && canImport(UIKit)
  import Testing
  import UIKit

  @testable import Textual

  @MainActor
  struct UITextInteractionViewTests {
    // 模拟系统私有的拖选识别器（UITextRefinementPanGestureRecognizer 等都是 UIPanGestureRecognizer 子类）
    private final class SelectionPanGestureRecognizer: UIPanGestureRecognizer {}

    // 模拟系统私有的多击识别器（UITextMultiTapRecognizer 直接继承 UIGestureRecognizer）
    private final class MultiTapGestureRecognizer: UIGestureRecognizer {}

    @Test
    func tapWaitsForDiscreteRecognizers() {
      #expect(UITextInteractionView.tapShouldRequireFailure(of: MultiTapGestureRecognizer()))
      #expect(UITextInteractionView.tapShouldRequireFailure(of: UITapGestureRecognizer()))
    }

    @Test
    func tapDoesNotWaitForContinuousRecognizers() {
      // 单击若依赖拖选识别器失败，会在双击间隔内把它们压在 failed，紧接着的按下拖选收不到触点
      #expect(!UITextInteractionView.tapShouldRequireFailure(of: SelectionPanGestureRecognizer()))
      #expect(!UITextInteractionView.tapShouldRequireFailure(of: UIPanGestureRecognizer()))
      #expect(!UITextInteractionView.tapShouldRequireFailure(of: UILongPressGestureRecognizer()))
      #expect(!UITextInteractionView.tapShouldRequireFailure(of: UIHoverGestureRecognizer()))
    }
  }
#endif
