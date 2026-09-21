#if os(iOS) && !targetEnvironment(macCatalyst)
  import SwiftUI
  import Testing
  import SnapshotTesting

  import Textual

  @MainActor
  struct TextLayoutCollectionTests {
    @Test func simpleInlineTextLayout() {
      let view = InlineText(markdown: "Hello world!")
        .padding(.horizontal)

      assertSnapshot(of: view, as: .textLayoutCollection())
    }

    @Test func multilineInlineTextLayout() {
      let view = InlineText(markdown: "Hello\nworld!")
        .padding(.horizontal)

      assertSnapshot(of: view, as: .textLayoutCollection())
    }

    @Test func multilineWithNewlinesInlineTextLayout() {
      let view = InlineText(markdown: "Hello\n\nworld!")
        .padding(.horizontal)

      assertSnapshot(of: view, as: .textLayoutCollection())
    }

    // 以换行开头的文本第一行没有 run：快照里必须仍有这一个 layout，否则整段不可选。
    @Test func leadingNewlinesInlineTextLayout() {
      struct VerbatimParser: MarkupParser {
        func attributedString(for input: String) throws -> AttributedString {
          AttributedString(input)
        }
      }
      let view = InlineText("\n\nlead abc def", parser: VerbatimParser())
        .padding(.horizontal)

      assertSnapshot(of: view, as: .textLayoutCollection())
    }

    @Test func twoParagraphsBidiStructuredTextLayout() {
      let view = StructuredText(
        markdown: """
          This is a **sample** paragraph with a [link](https://example.com) and \u{2067}مرحبا\u{2069}.

          Another *sample* paragraph with `code` and \u{2067}كيف حالك؟\u{2069}.
          """
      ).padding()

      assertSnapshot(of: view, as: .textLayoutCollection())
    }
  }
#endif
