//
//  CodeView.swift
//  
//
//  Created by Manuel M T Chakravarty on 05/05/2021.
//
//  This file contains both the macOS and iOS versions of the subclass for `NSTextView` and `UITextView`, respectively,
//  which forms the heart of the code editor.

import SwiftUI


// MARK: -
// MARK: Message info

/// Information required to layout message views.
///
/// NB: This information is computed incrementally. We get the `lineFragementRect` from the text container during the
///     type setting processes. This indicates that the message layout may have to change (if it was already
///     computed), but at this point, we cannot determine the new geometry yet; hence, `geometry` will be `nil`.
///     The `geomtry` will be determined after text layout is complete.
///
struct MessageInfo {
  let view:               StatefulMessageView.HostingView
  var lineFragementRect:  CGRect                            // The *full* line fragement rectangle (incl. message)
  var geometry:           MessageView.Geometry?
  var colour:             OSColor                           // The category colour of the most severe category

  var topAnchorConstraint:   NSLayoutConstraint?
  var rightAnchorConstraint: NSLayoutConstraint?
}

/// Dictionary of message views.
///
typealias MessageViews = [LineInfo.MessageBundle.ID: MessageInfo]


#if os(iOS)

// MARK: -
// MARK: UIKit version

/// `UITextView` with a gutter
///
class CodeView: UITextView {

  // Delegates
  fileprivate var codeViewDelegate:           CodeViewDelegate?
  fileprivate var codeStorageDelegate:        CodeStorageDelegate
  fileprivate let codeLayoutManagerDelegate = CodeLayoutManagerDelegate()

  // Subviews
  fileprivate var gutterView: GutterView?

  /// The current highlighting theme
  ///
  var theme: Theme {
    didSet {
      font                                 = UIFont(name: theme.fontName, size: theme.fontSize)
      backgroundColor                      = theme.backgroundColour
      tintColor                            = theme.tintColour
      (textStorage as? CodeStorage)?.theme = theme
      gutterView?.theme                    = theme
      setNeedsDisplay(bounds)
    }
  }

  /// The current view layout.
  ///
  var viewLayout: CodeEditor.LayoutConfiguration {
    didSet {
      // Nothing to do, but that may change in the future
    }
  }

  /// Keeps track of the set of message views.
  ///
  var messageViews: MessageViews = [:]

  /// Designated initializer for code views with a gutter.
  ///
  init(frame: CGRect, with language: LanguageConfiguration, viewLayout: CodeEditor.LayoutConfiguration, theme: Theme) {

    self.viewLayout = viewLayout
    self.theme      = theme

    // Use custom components that are gutter-aware and support code-specific editing actions and highlighting.
    let codeLayoutManager         = CodeLayoutManager(),
        codeContainer             = CodeContainer(),
        codeStorage               = CodeStorage(theme: theme)
    codeStorage.addLayoutManager(codeLayoutManager)
    codeContainer.layoutManager = codeLayoutManager
    codeLayoutManager.addTextContainer(codeContainer)
    codeLayoutManager.delegate = codeLayoutManagerDelegate

    codeStorageDelegate = CodeStorageDelegate(with: language)

    super.init(frame: frame, textContainer: codeContainer)
    codeContainer.textView = self

    // Set basic display and input properties
    font                   = theme.font
    backgroundColor        = theme.backgroundColour
    tintColor              = theme.tintColour
    autocapitalizationType = .none
    autocorrectionType     = .no
    spellCheckingType      = .no
    smartQuotesType        = .no
    smartDashesType        = .no
    smartInsertDeleteType  = .no

    // Add the view delegate
    codeViewDelegate = CodeViewDelegate(codeView: self)
    delegate         = codeViewDelegate

    // Add a text storage delegate that maintains a line map
    codeStorage.delegate = self.codeStorageDelegate

    // Add a gutter view
    let gutterWidth = ceil(theme.fontSize) * 3,
        gutterView  = GutterView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: gutterWidth,
                                               height: CGFloat.greatestFiniteMagnitude),
                                 textView: self,
                                 theme: theme,
                                 getMessageViews: { self.messageViews })
    addSubview(gutterView)
    self.gutterView              = gutterView
    codeLayoutManager.gutterView = gutterView
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    gutterView?.frame.size.height = contentSize.height
  }
}

class CodeViewDelegate: NSObject, UITextViewDelegate {

  // Hooks for events
  //
  var textDidChange:      ((UITextView) -> ())?
  var selectionDidChange: ((UITextView) -> ())?
  var didScroll:          ((UIScrollView) -> ())?

  /// Caching the last set selected range.
  ///
  var oldSelectedRange: NSRange

  init(codeView: CodeView) {
    oldSelectedRange = codeView.selectedRange
  }

  // MARK: -
  // MARK: UITextViewDelegate protocol

  func textViewDidChange(_ textView: UITextView) { textDidChange?(textView) }

  func textViewDidChangeSelection(_ textView: UITextView) {
    guard let codeView = textView as? CodeView else { return }

    selectionDidChange?(textView)

    // NB: Invalidation of the two ranges needs to happen separately. If we were to union them, an insertion point
    //     (range length = 0) at the start of a line would be absorbed into the previous line, which results in a lack
    //     of invalidation of the line on which the insertion point is located.
    codeView.gutterView?.invalidateGutter(forCharRange: codeView.selectedRange)
    codeView.gutterView?.invalidateGutter(forCharRange: oldSelectedRange)
    oldSelectedRange = textView.selectedRange
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) { didScroll?(scrollView) }
}

#elseif os(macOS)

// MARK: -
// MARK: AppKit version

/// `NSTextView` with a gutter
///
class CodeView: NSTextView {

  // Delegates
  fileprivate let codeViewDelegate =          CodeViewDelegate()
  fileprivate let codeLayoutManagerDelegate = CodeLayoutManagerDelegate()
  fileprivate var codeStorageDelegate:        CodeStorageDelegate

  // Subviews
  var gutterView:         GutterView?
  var minimapView:        NSTextView?
  var minimapGutterView:  GutterView?
  var documentVisibleBox: NSBox?
  var minimapDividerView: NSBox?

  /// Contains the line on which the insertion point was located, the last time the selection range got set (if the
  /// selection was an insetion point at all; i.e., it's length was 0).
  ///
  var oldLastLineOfInsertionPoint: Int? = 1

  /// The current highlighting theme
  ///
  var theme: Theme {
    didSet {
      font                                 = theme.font
      backgroundColor                      = theme.backgroundColour
      insertionPointColor                  = theme.cursorColour
      selectedTextAttributes               = [.backgroundColor: theme.selectionColour]
      (textStorage as? CodeStorage)?.theme = theme
      gutterView?.theme                    = theme
      minimapView?.backgroundColor         = theme.backgroundColour
      minimapGutterView?.theme             = theme
      documentVisibleBox?.fillColor        = theme.textColour.withAlphaComponent(0.1)
      tile()
      setNeedsDisplay(visibleRect)
    }
  }

  /// The current view layout.
  ///
  var viewLayout: CodeEditor.LayoutConfiguration {
    didSet { tile() }
  }

  /// Keeps track of the set of message views.
  ///
  var messageViews: MessageViews = [:]

  /// Designated initialiser for code views with a gutter.
  ///
  init(frame: CGRect, with language: LanguageConfiguration, viewLayout: CodeEditor.LayoutConfiguration, theme: Theme) {

    self.theme      = theme
    self.viewLayout = viewLayout

    // Use custom components that are gutter-aware and support code-specific editing actions and highlighting.
    let codeLayoutManager = CodeLayoutManager(),
        codeContainer     = CodeContainer(),
        codeStorage       = CodeStorage(theme: theme)
    codeStorage.addLayoutManager(codeLayoutManager)
    codeContainer.layoutManager = codeLayoutManager
    codeLayoutManager.addTextContainer(codeContainer)
    codeLayoutManager.delegate = codeLayoutManagerDelegate

    codeStorageDelegate  = CodeStorageDelegate(with: language)

    super.init(frame: frame, textContainer: codeContainer)

    // Set basic display and input properties
    font                                 = theme.font
    backgroundColor                      = theme.backgroundColour
    insertionPointColor                  = theme.cursorColour
    selectedTextAttributes               = [.backgroundColor: theme.selectionColour]
    isRichText                           = false
    isAutomaticQuoteSubstitutionEnabled  = false
    isAutomaticLinkDetectionEnabled      = false
    smartInsertDeleteEnabled             = false
    isContinuousSpellCheckingEnabled     = false
    isGrammarCheckingEnabled             = false
    isAutomaticDashSubstitutionEnabled   = false
    isAutomaticDataDetectionEnabled      = false
    isAutomaticSpellingCorrectionEnabled = false
    isAutomaticTextReplacementEnabled    = false
    usesFontPanel                        = false

    // Line wrapping
    isHorizontallyResizable             = false
    isVerticallyResizable               = true
    textContainerInset                  = CGSize(width: 0, height: 0)
    textContainer?.widthTracksTextView  = false   // we need to be able to control the size (see `tile()`)
    textContainer?.heightTracksTextView = false
    textContainer?.lineBreakMode        = .byWordWrapping

    // FIXME: properties that ought to be configurable
    usesFindBar                   = true
    isIncrementalSearchingEnabled = true

    // Add the view delegate
    delegate = codeViewDelegate

    // Add a text storage delegate that maintains a line map
    codeStorage.delegate = codeStorageDelegate

    // Add a gutter view
    let gutterView = GutterView(frame: CGRect.zero,
                                textView: self,
                                theme: theme,
                                getMessageViews: { self.messageViews },
                                isMinimapGutter: false)
    gutterView.autoresizingMask = .none
    addSubview(gutterView)
    self.gutterView              = gutterView
    codeLayoutManager.gutterView = gutterView

    // Add the minimap with its own gutter, but sharing the code storage with the code view
    //
    let minimapLayoutManager = MinimapLayoutManager(),
        minimapView          = MinimapView(),
        minimapGutterView    = GutterView(frame: CGRect.zero,
                                          textView: minimapView,
                                          theme: theme,
                                          getMessageViews: { self.messageViews },
                                          isMinimapGutter: true),
        minimapDividerView   = NSBox()
    minimapView.codeView = self

    minimapDividerView.boxType = .separator
    addSubview(minimapDividerView)
    self.minimapDividerView = minimapDividerView

    minimapView.textContainer?.replaceLayoutManager(minimapLayoutManager)
    codeStorage.addLayoutManager(minimapLayoutManager)
    minimapView.backgroundColor                     = backgroundColor
    minimapView.autoresizingMask                    = .none
    minimapView.isEditable                          = false
    minimapView.isSelectable                        = false
    minimapView.isHorizontallyResizable             = false
    minimapView.isVerticallyResizable               = true
    minimapView.textContainerInset                  = CGSize(width: 0, height: 0)
    minimapView.textContainer?.widthTracksTextView  = true
    minimapView.textContainer?.heightTracksTextView = false
    minimapView.textContainer?.lineBreakMode        = .byWordWrapping
    addSubview(minimapView)
    self.minimapView = minimapView

    minimapView.addSubview(minimapGutterView)
    self.minimapGutterView = minimapGutterView

    minimapView.layoutManager?.typesetter = MinimapTypeSetter()

    let documentVisibleBox = NSBox()
    documentVisibleBox.boxType     = .custom
    documentVisibleBox.fillColor   = theme.textColour.withAlphaComponent(0.1)
    documentVisibleBox.borderWidth = 0
    minimapView.addSubview(documentVisibleBox)
    self.documentVisibleBox = documentVisibleBox

    tile()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layout() {
    super.layout()

    // Lay out the various subviews and text containers
    tile()

    // Redraw the visible part of the gutter
    gutterView?.setNeedsDisplay(documentVisibleRect)
  }

  override func setSelectedRanges(_ ranges: [NSValue],
                                  affinity: NSSelectionAffinity,
                                  stillSelecting stillSelectingFlag: Bool)
  {
    let oldSelectedRanges = selectedRanges
    super.setSelectedRanges(ranges, affinity: affinity, stillSelecting: stillSelectingFlag)
    minimapView?.selectedRanges = selectedRanges    // minimap mirrors the selection of the main code view

    let lineOfInsertionPoint = insertionPoint.flatMap{ optLineMap?.lineOf(index: $0) }

    // If the insertion point changed lines, we need to redraw at the old and new location to fix the line highlighting.
    // NB: We retain the last line and not the character index as the latter may be inaccurate due to editing that let
    //     to the selected range change.
    if lineOfInsertionPoint != oldLastLineOfInsertionPoint {

      if let oldLine      = oldLastLineOfInsertionPoint,
         let oldLineRange = optLineMap?.lookup(line: oldLine)?.range
      {

        // We need to invalidate the whole background (incl message views); hence, we need to employ
        // `lineBackgroundRect(_:)`, which is why `NSLayoutManager.invalidateDisplay(forCharacterRange:)` is not
        // sufficient.
        layoutManager?.enumerateFragmentRects(forLineContaining: oldLineRange.location){ fragmentRect in

          self.setNeedsDisplay(self.lineBackgroundRect(fragmentRect))
        }
        minimapGutterView?.optLayoutManager?.invalidateDisplay(forCharacterRange: oldLineRange)

      }
      if let newLine      = lineOfInsertionPoint,
         let newLineRange = optLineMap?.lookup(line: newLine)?.range
      {

        // We need to invalidate the whole background (incl message views); hence, we need to employ
        // `lineBackgroundRect(_:)`, which is why `NSLayoutManager.invalidateDisplay(forCharacterRange:)` is not
        // sufficient.
        layoutManager?.enumerateFragmentRects(forLineContaining: newLineRange.location){ fragmentRect in

          self.setNeedsDisplay(self.lineBackgroundRect(fragmentRect))
        }
        minimapGutterView?.optLayoutManager?.invalidateDisplay(forCharacterRange: newLineRange)

      }
    }
    oldLastLineOfInsertionPoint = lineOfInsertionPoint

    // NB: This needs to happen after calling `super`, as it depends on the correctly set new set of ranges.
    DispatchQueue.main.async {

      // Needed as the selection affects line number highlighting.
      // NB: Invalidation of the old and new ranges needs to happen separately. If we were to union them, an insertion
      //     point (range length = 0) at the start of a line would be absorbed into the previous line, which results in
      //     a lack of invalidation of the line on which the insertion point is located.
      self.gutterView?.invalidateGutter(forCharRange: combinedRanges(ranges: oldSelectedRanges))
      self.gutterView?.invalidateGutter(forCharRange: combinedRanges(ranges: ranges))
      self.minimapGutterView?.invalidateGutter(forCharRange: combinedRanges(ranges: oldSelectedRanges))
      self.minimapGutterView?.invalidateGutter(forCharRange: combinedRanges(ranges: ranges))
    }

    collapseMessageViews()
  }

  override func drawBackground(in rect: NSRect) {
    super.drawBackground(in: rect)

    guard let layoutManager = layoutManager,
          let textContainer = textContainer
    else { return }

    let glyphRange = layoutManager.glyphRange(forBoundingRectWithoutAdditionalLayout: rect, in: textContainer),
        charRange  = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

    // If the selection is an insertion point, highlight the corresponding line
    if let location = insertionPoint, charRange.contains(location) || location == NSMaxRange(charRange) {

      drawBackgroundHighlight(in: rect, forLineContaining: location, withColour: theme.currentLineColour)

    }

    // Highlight each line that has a message view
    for messageView in messageViews {

      let glyphRange = layoutManager.glyphRange(forBoundingRect: messageView.value.lineFragementRect, in: textContainer),
          index      = layoutManager.characterIndexForGlyph(at: glyphRange.location)

// This seems like a worthwhile optimisation, but sometimes we are called in a situation, where `charRange` computes
// to be the empty range although the whole visible area is being redrawn.
//      if charRange.contains(index) {

        drawBackgroundHighlight(in: rect,
                                forLineContaining: index,
                                withColour: messageView.value.colour.withAlphaComponent(0.1))

//      }
    }
  }

  /// Draw the background of an entire line of text with a highlight colour, including below any messages views.
  ///
  private func drawBackgroundHighlight(in rect: NSRect, forLineContaining charIndex: Int, withColour colour: NSColor) {
    guard let layoutManager = layoutManager else { return }

    colour.setFill()
    layoutManager.enumerateFragmentRects(forLineContaining: charIndex){ fragmentRect in

      let drawRect = self.lineBackgroundRect(fragmentRect).intersection(rect)
      if !drawRect.isNull { NSBezierPath(rect: drawRect).fill() }
    }
  }

  /// Compute the background rect from a line's fragement rect. On lines that contain a message view, the fragement
  /// rect doesn't cover the entire background.
  ///
  private func lineBackgroundRect(_ lineFragementRect: CGRect) -> CGRect {

    if let textContainerWidth = textContainer?.size.width {

      return CGRect(origin: lineFragementRect.origin,
                    size: CGSize(width: textContainerWidth - lineFragementRect.minX, height: lineFragementRect.height))

    } else {

      return lineFragementRect

    }
  }

  /// Position and size the gutter and minimap and set the text container sizes and exclusion paths. Take the current
  /// view layout in `viewLayout` into account.
  ///
  /// * The main text view contains three subviews: (1) the main gutter on its left side, (2) the minimap on its right
  ///   side, and (3) a divide in between the code view and the minimap gutter.
  /// * Both the main text view and the minimap text view (or rather their text container) uses an exclusion path to
  ///   keep text out of the gutter view. The main text view is sized to avoid overlap with the minimap even without an
  ///   exclusion path.
  /// * The main text view and the minimap text view need to be able to accomodate exactly the same number of
  ///   characters, so that line breaking procceds in the exact same way.
  ///
  /// NB: We don't use a ruler view for the gutter on macOS to be able to use the same setup on macOS and iOS.
  ///
  private func tile() {

    // Compute size of the main view gutter
    //
    let theFont                = font ?? NSFont.systemFont(ofSize: 0),
        fontSize               = theFont.pointSize,
        fontWidth              = theFont.maximumAdvancement.width,  // NB: we deal only with fixed width fonts
        gutterWithInCharacters = CGFloat(6),
        gutterWidth            = ceil(fontWidth * gutterWithInCharacters),
        gutterRect             = CGRect(origin: CGPoint.zero, size: CGSize(width: gutterWidth, height: frame.height)),
        gutterExclusionPath    = OSBezierPath(rect: gutterRect),
        minLineFragmentPadding = CGFloat(6)

    gutterView?.frame = gutterRect

    // Compute sizes of the minimap text view and gutter
    //
    let minimapFontWidth     = minimapFontSize(for: fontSize) / 2,
        minimapGutterWidth   = minimapFontWidth * gutterWithInCharacters,
        dividerWidth         = CGFloat(1),
        minimapGutterRect    = CGRect(origin: CGPoint.zero,
                                      size: CGSize(width: minimapGutterWidth, height: frame.height)),
        widthWithoutGutters  = frame.width - gutterWidth - minimapGutterWidth
                                           - minLineFragmentPadding * 2 + minimapFontWidth * 2 - dividerWidth,
        numberOfCharacters   = codeWidthInCharacters(for: widthWithoutGutters,
                                                     with: theFont,
                                                     withMinimap: viewLayout.showMinimap),
        minimapWidth         = minimapGutterWidth + minimapFontWidth * 2 + numberOfCharacters * minimapFontWidth,
        codeViewWidth        = viewLayout.showMinimap ? frame.width - minimapWidth - dividerWidth : frame.width,
        padding              = codeViewWidth - (gutterWidth + ceil(numberOfCharacters * fontWidth)),
        minimapX             = floor(frame.width - minimapWidth),
        minimapRect          = CGRect(x: minimapX, y: 0, width: minimapWidth, height: frame.height),
        minimapExclusionPath = OSBezierPath(rect: minimapGutterRect),
        minimapDividerRect   = CGRect(x: minimapX - dividerWidth, y: 0, width: dividerWidth, height: frame.height)

    minimapDividerView?.isHidden = !viewLayout.showMinimap
    minimapView?.isHidden        = !viewLayout.showMinimap
    if viewLayout.showMinimap {

      minimapDividerView?.frame = minimapDividerRect
      minimapView?.frame        = minimapRect
      minimapGutterView?.frame  = minimapGutterRect

    }

    minSize = CGSize(width: 0, height: documentVisibleRect.height)
    maxSize = CGSize(width: codeViewWidth, height: CGFloat.greatestFiniteMagnitude)

    // Set the text container area of the main text view to reach up to the minimap
    // NB: We use the `lineFragmentPadding` to capture the slack that arises when the window width admits a fractional
    //     number of characters. Adding the slack to the code view's text container doesn't work as the line breaks
    //     of the minimap and main code view are then sometimes not entirely in sync.
    textContainerInset                 = NSSize(width: 0, height: 0)
    textContainer?.size                = NSSize(width: codeViewWidth, height: CGFloat.greatestFiniteMagnitude)
    textContainer?.lineFragmentPadding = padding / 2
    textContainer?.exclusionPaths      = [gutterExclusionPath]

    // Set the text container area of the minimap text view
    minimapView?.textContainer?.exclusionPaths      = [minimapExclusionPath]
    minimapView?.textContainer?.size                = CGSize(width: minimapWidth,
                                                             height: CGFloat.greatestFiniteMagnitude)
    minimapView?.textContainer?.lineFragmentPadding = minimapFontWidth

    // NB: We can't set the height of the box highlighting the document visible area here as it depends on the document
    //     and minimap height, which requires document layout to be completed. Hence, we delay that.
    DispatchQueue.main.async { self.adjustScrollPositionOfMinimap() }
  }

  /// Sets the scrolling position of the minimap in dependence of the scroll position of the main code view.
  ///
  func adjustScrollPositionOfMinimap() {
    guard viewLayout.showMinimap else { return }

    let codeViewHeight = frame.size.height,
        minimapHeight  = minimapView?.frame.size.height ?? 0,
        visibleHeight  = documentVisibleRect.size.height

    let scrollFactor: CGFloat
    if minimapHeight < visibleHeight { scrollFactor = 1 } else {

      scrollFactor = 1 - (minimapHeight - visibleHeight) / (codeViewHeight - visibleHeight)

    }

    // We box the positioning of the minimap at the top and the bottom of the code view (with the `max` and `min`
    // expessions. This is necessary as the minimap will otherwise be partially cut off by the enclosing clip view.
    // If we want an Xcode-like behaviour, where the minimap sticks to the top, it probably would need to be a floating
    // view outside of the clip view.
    let newOriginY = floor(min(max(documentVisibleRect.origin.y * scrollFactor, 0),
                               frame.size.height - (minimapView?.frame.size.height ?? 0)))
    if minimapView?.frame.origin.y != newOriginY { minimapView?.frame.origin.y = newOriginY }  // don't update frames in vain

    let minimapVisibleY      = (visibleRect.origin.y / frame.size.height) * minimapHeight,
        minimapVisibleHeight = documentVisibleRect.size.height * minimapHeight / frame.size.height,
        documentVisibleFrame = CGRect(x: 0,
                                      y: minimapVisibleY,
                                      width: minimapView?.bounds.size.width ?? 0,
                                      height: minimapVisibleHeight).integral
    if documentVisibleBox?.frame != documentVisibleFrame { documentVisibleBox?.frame = documentVisibleFrame }
  }

}

class CodeViewDelegate: NSObject, NSTextViewDelegate {

  // Hooks for events
  //
  var textDidChange:      ((NSTextView) -> ())?
  var selectionDidChange: ((NSTextView) -> ())?

  // MARK: NSTextViewDelegate protocol

  func textDidChange(_ notification: Notification) {
    guard let textView = notification.object as? NSTextView else { return }

    textDidChange?(textView)
  }

  func textViewDidChangeSelection(_ notification: Notification) {
    guard let textView = notification.object as? NSTextView else { return }

    selectionDidChange?(textView)
  }
}

#endif


// MARK: -
// MARK: Shared code

extension CodeView {

  /// Update the layout of the specified message view if its geometry got invalidated by
  /// `CodeTextContainer.lineFragmentRect(forProposedRect:at:writingDirection:remaining:)`.
  ///
  fileprivate func layoutMessageView(identifiedBy id: UUID) {
    guard let codeLayoutManager = layoutManager as? CodeLayoutManager,
          let codeStorage       = textStorage as? CodeStorage,
          let codeContainer     = optTextContainer,
          let messageBundle     = messageViews[id]
    else { return }

    if messageBundle.geometry == nil {

      let glyphRange = codeLayoutManager.glyphRange(forBoundingRect: messageBundle.lineFragementRect, in: codeContainer),
          charRange  = codeLayoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil),
          lineRange  = (codeStorage.string as NSString).lineRange(for: charRange),
          lineGlyphs = codeLayoutManager.glyphRange(forCharacterRange: lineRange, actualCharacterRange: nil),
          usedRect   = codeLayoutManager.lineFragmentUsedRect(forGlyphAt: glyphRange.location, effectiveRange: nil),
          lineRect   = codeLayoutManager.boundingRect(forGlyphRange: lineGlyphs, in: codeContainer)

      // Compute the message view geometry from the text layout information
      let geometry = MessageView.Geometry(lineWidth: messageBundle.lineFragementRect.width - usedRect.width,
                                          lineHeight: messageBundle.lineFragementRect.height,
                                          popupWidth:
                                            (codeContainer.size.width - MessageView.popupRightSideOffset) * 0.75,
                                          popupOffset: lineRect.height + 2)
      messageViews[id]?.geometry = geometry

      // Configure the view with the new geometry
      messageBundle.view.geometry = geometry
      if messageBundle.view.superview == nil {

        // Add the messages view
        addSubview(messageBundle.view)
        let topOffset = textContainerOrigin.y + messageBundle.lineFragementRect.minY,
            topAnchorConstraint = messageBundle.view.topAnchor.constraint(equalTo: self.topAnchor,
                                                                          constant: topOffset)
        let leftOffset = textContainerOrigin.x + messageBundle.lineFragementRect.maxX,
            rightAnchorConstraint = messageBundle.view.rightAnchor.constraint(equalTo: self.leftAnchor,
                                                                              constant: leftOffset)
        messageViews[id]?.topAnchorConstraint   = topAnchorConstraint
        messageViews[id]?.rightAnchorConstraint = rightAnchorConstraint
        NSLayoutConstraint.activate([topAnchorConstraint, rightAnchorConstraint])


      } else {

        // Update the messages view constraints
        messageViews[id]?.topAnchorConstraint?.constant   = messageBundle.lineFragementRect.minY
        messageViews[id]?.rightAnchorConstraint?.constant = messageBundle.lineFragementRect.maxX

      }
    }
  }

  /// Adds a new message to the set of messages for this code view.
  ///
  func report(message: Located<Message>) {
    guard let messageBundle = codeStorageDelegate.add(message: message) else { return }

    updateMessageView(for: messageBundle, at: message.location.line)
  }

  /// Removes a given message. If it doesn't exist, do nothing. This function is quite expensive.
  ///
  func retract(message: Message) {
    guard let (messageBundle, line) = codeStorageDelegate.remove(message: message) else { return }

    updateMessageView(for: messageBundle, at: line)
  }

  /// Given a new or updated message bundle, update the corresponding message view appropriately. This includes covering
  /// the two special cases, where we create a new view or we remove a view for good (as its last message was deleted).
  ///
  private func updateMessageView(for messageBundle: LineInfo.MessageBundle, at line: Int) {
    guard let charRange = codeStorageDelegate.lineMap.lookup(line: line)?.range else { return }

    removeMessageViews(withIDs: [messageBundle.id])

    // If we removed the last message of this view, we don't need to create a new version
    if messageBundle.messages.isEmpty { return }

    // TODO: CodeEditor needs to be parameterised by message theme
    let theme = Message.defaultTheme

    let messageView = StatefulMessageView.HostingView(messages: messageBundle.messages,
                                                      theme: theme,
                                                      geometry: MessageView.Geometry(lineWidth: 100,
                                                                                     lineHeight: 15,
                                                                                     popupWidth: 300,
                                                                                     popupOffset: 16),
                                                      fontSize: font?.pointSize ?? OSFont.systemFontSize),
        principalCategory = messagesByCategory(messageBundle.messages)[0].key,
        colour            = theme(principalCategory).colour

    messageViews[messageBundle.id] = MessageInfo(view: messageView,
                                                 lineFragementRect: CGRect.zero,
                                                 geometry: nil,
                                                 colour: colour)

    // We invalidate the layout of the line where the message belongs as their may be less space for the text now and
    // because the layout process for the text fills the `lineFragmentRect` property of the above `MessageInfo`.
    optLayoutManager?.invalidateLayout(forCharacterRange: charRange, actualCharacterRange: nil)
    self.optLayoutManager?.invalidateDisplay(forCharacterRange: charRange)
    gutterView?.invalidateGutter(forCharRange: charRange)
  }

  /// Remove the messages associated with a specified range of lines.
  ///
  /// - Parameter onLines: The line range where messages are to be removed. If `nil`, all messages on this code view are
  ///     to be removed.
  ///
  func retractMessages(onLines lines: Range<Int>? = nil) {
    var messageIds: [LineInfo.MessageBundle.ID] = []

    // Remove all message bundles in the line map and collect their ids for subsequent view removal.
    for line in lines ?? 1..<codeStorageDelegate.lineMap.lines.count {

      if let messageBundle = codeStorageDelegate.messages(at: line) {

        messageIds.append(messageBundle.id)
        codeStorageDelegate.removeMessages(at: line)

      }

    }

    // Make sure to remove all views that are still around if necessary.
    if lines == nil { removeMessageViews() } else { removeMessageViews(withIDs: messageIds) }
  }

  /// Remove the message views with the given ids.
  ///
  /// - Parameter ids: The IDs of the message bundles that ought to be removed. If `nil`, remove all.
  ///
  /// IDs that do not have no associated message view cause no harm.
  ///
  fileprivate func removeMessageViews(withIDs ids: [LineInfo.MessageBundle.ID]? = nil) {

    for id in ids ?? Array<LineInfo.MessageBundle.ID>(messageViews.keys) {

      if let info = messageViews[id] { info.view.removeFromSuperview() }
      messageViews.removeValue(forKey: id)

    }
  }

  /// Ensure that all message views are in their collapsed state.
  ///
  func collapseMessageViews() {
    for messageView in messageViews {
      messageView.value.view.unfolded = false
    }
  }

}

class CodeContainer: NSTextContainer {

  #if os(iOS)
  weak var textView: UITextView?
  #endif

  override func lineFragmentRect(forProposedRect proposedRect: CGRect,
                                 at characterIndex: Int,
                                 writingDirection baseWritingDirection: NSWritingDirection,
                                 remaining remainingRect: UnsafeMutablePointer<CGRect>?)
  -> CGRect
  {
    let calculatedRect = super.lineFragmentRect(forProposedRect: proposedRect,
                                                at: characterIndex,
                                                writingDirection: baseWritingDirection,
                                                remaining: remainingRect)

    guard let codeView    = textView as? CodeView,
          let codeStorage = layoutManager?.textStorage as? CodeStorage,
          let delegate    = codeStorage.delegate as? CodeStorageDelegate,
          let line        = delegate.lineMap.lineOf(index: characterIndex),
          let oneLine     = delegate.lineMap.lookup(line: line),
          characterIndex == oneLine.range.location    // we are only interested in the first line fragment of a line
    else { return calculatedRect }

    // On lines that contain messages, we reduce the width of the available line fragement rect such that there is
    // always space for a minimal truncated message (provided the text container is wide enough to accomodate that).
    if let messageBundleId = delegate.messages(at: line)?.id,
       calculatedRect.width > 2 * MessageView.minimumInlineWidth
    {

      codeView.messageViews[messageBundleId]?.lineFragementRect = calculatedRect
      codeView.messageViews[messageBundleId]?.geometry = nil                      // invalidate the geometry

      // To fully determine the layout of the message view, typesetting needs to complete for this line; hence, we defer
      // configuring the view.
      DispatchQueue.main.async { codeView.layoutMessageView(identifiedBy: messageBundleId) }

      return CGRect(origin: calculatedRect.origin,
                    size: CGSize(width: calculatedRect.width - MessageView.minimumInlineWidth,
                                 height: calculatedRect.height))

    } else { return calculatedRect }
  }
}

/// Customised layout manager for code layout.
///
class CodeLayoutManager: NSLayoutManager {

  weak var gutterView: GutterView?

  override func processEditing(for textStorage: NSTextStorage,
                               edited editMask: TextStorageEditActions,
                               range newCharRange: NSRange,
                               changeInLength delta: Int,
                               invalidatedRange invalidatedCharRange: NSRange) {
    super.processEditing(for: textStorage,
                         edited: editMask,
                         range: newCharRange,
                         changeInLength: delta,
                         invalidatedRange: invalidatedCharRange)

    // NB: Gutter drawing must be asynchronous, as the glyph generation that may be triggered in that process,
    //     is not permitted until the enclosing editing block has completed; otherwise, we run into an internal
    //     error in the layout manager.
    if let gutterView = gutterView {
      Dispatch.DispatchQueue.main.async { gutterView.invalidateGutter(forCharRange: invalidatedCharRange) }
    }

    // Remove all messages in the edited range.
    if let codeStorageDelegate = textStorage.delegate as? CodeStorageDelegate,
       let codeView            = gutterView?.textView as? CodeView
    {

      codeView.removeMessageViews(withIDs: codeStorageDelegate.lastEvictedMessageIDs)

    }
  }
}

class CodeLayoutManagerDelegate: NSObject, NSLayoutManagerDelegate {

  func layoutManager(_ layoutManager: NSLayoutManager,
                     didCompleteLayoutFor textContainer: NSTextContainer?,
                     atEnd layoutFinishedFlag: Bool)
  {
    guard let layoutManager = layoutManager as? CodeLayoutManager else { return }

    if layoutFinishedFlag { layoutManager.gutterView?.layoutFinished() }
  }
}

/// Common code view actions triggered on a selection change.
///
func selectionDidChange<TV: TextView>(_ textView: TV) {
  guard let layoutManager = textView.optLayoutManager,
        let textContainer = textView.optTextContainer,
        let codeStorage   = textView.optCodeStorage
        else { return }

  let visibleRect = textView.documentVisibleRect,
      glyphRange  = layoutManager.glyphRange(forBoundingRectWithoutAdditionalLayout: visibleRect,
                                             in: textContainer),
      charRange   = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

  if let location             = textView.insertionPoint,
     location > 0,
     let matchingBracketRange = codeStorage.matchingBracket(forLocationAt: location - 1, in: charRange)
  {
    textView.showFindIndicator(for: matchingBracketRange)
  }
}

extension NSLayoutManager {

  /// Enumerate the fragment rectangles covering the characters located on the line with the given character index.
  ///
  /// - Parameters:
  ///   - charIndex: The character index determining the line whose rectangles we want to enumerate.
  ///   - block: Block that gets invoked once for every fragement rectangles on that line.
  ///
  func enumerateFragmentRects(forLineContaining charIndex: Int, using block: @escaping (CGRect) -> Void) {
    guard let text = textStorage?.string as NSString? else { return }

    let currentLineCharRange = text.lineRange(for: NSRange(location: charIndex, length: 0))

    if currentLineCharRange.length > 0 {  // all, but the last line (if it is an empty line)

      let currentLineGlyphRange = glyphRange(forCharacterRange: currentLineCharRange, actualCharacterRange: nil)
      enumerateLineFragments(forGlyphRange: currentLineGlyphRange){ (rect, _, _, _, _) in block(rect) }

    } else {                              // the last line if it is an empty line

      block(extraLineFragmentRect)

    }
  }
}

/// Combine selection ranges into the smallest ranges encompassing them all.
///
private func combinedRanges(ranges: [NSValue]) -> NSRange {
  let actualranges = ranges.compactMap{ $0 as? NSRange }
  return actualranges.dropFirst().reduce(actualranges.first ?? NSRange(location: 0, length: 0)) {
    NSUnionRange($0, $1)
  }
}


