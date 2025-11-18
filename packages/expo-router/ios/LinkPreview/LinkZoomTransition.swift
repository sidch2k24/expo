import ExpoModulesCore
import UIKit

class LinkZoomTransitionsSourceRepository {
  static var sharedRepository: LinkZoomTransitionsSourceRepository = {
    return LinkZoomTransitionsSourceRepository()
  }()
  private var sources: [String: UIView] = [:]

  private init() {}

  func registerSource(
    identifier: String,
    source: UIView
  ) {
    if sources[identifier] != nil {
      print(
        "[expo-router] LinkPreviewZoomTransitionSource with identifier \(identifier) is already registered. Overwriting the existing source."
      )
    }
    sources[identifier] = source
  }

  func unregisterSource(identifier: String) {
    sources.removeValue(forKey: identifier)
  }

  func getSource(identifier: String) -> UIView? {
    return sources[identifier]
  }
}

class LinkZoomTransitionSource: ExpoView {
  // Keep track of the previous identifier to unregister it
  private var previousIdentifier: String?
  private var child: UIView?

  var identifier: String = "" {
    didSet {
      // Unregister old identifier if it exists
      if let oldID = previousIdentifier, !oldID.isEmpty {
        LinkZoomTransitionsSourceRepository.sharedRepository.unregisterSource(
          identifier: oldID)
      }

      // Register the new identifier if the view is in the hierarchy
      if child != nil && !identifier.isEmpty {
        LinkZoomTransitionsSourceRepository.sharedRepository.registerSource(
          identifier: identifier,
          source: child!
        )
      }

      previousIdentifier = identifier
    }
  }

  override func mountChildComponentView(
    _ childComponentView: UIView,
    index: Int
  ) {
    if child != nil {
      print(
        "[expo-router] LinkZoomTransitionSource can only have one child view."
      )
      return
    }
    child = childComponentView
    if identifier.isEmpty == false {
      LinkZoomTransitionsSourceRepository.sharedRepository.registerSource(
        identifier: identifier,
        source: childComponentView
      )
    }
    super.mountChildComponentView(childComponentView, index: index)
  }

  override func unmountChildComponentView(_ child: UIView, index: Int) {
    if child == child {
      self.child = nil
      if identifier.isEmpty == false {
        LinkZoomTransitionsSourceRepository.sharedRepository.unregisterSource(
          identifier: identifier
        )
      }
    }
    super.unmountChildComponentView(child, index: index)
  }
}

class LinkZoomTransitionEnabler: ExpoView {
  var zoomTransitionSourceIdentifier: String = ""

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    if superview != nil {
      // Need to run this async. Otherwise the view has no view controller yet
      DispatchQueue.main.async {
        self.setupZoomTransition()
      }
    }
  }

  func setupZoomTransition() {
    if self.zoomTransitionSourceIdentifier.isEmpty {
      print("[expo-router] No zoomTransitionSourceIdentifier passed to LinkZoomTransitionEnabler")
      return
    }
    if let controller = self.findViewController() {
      if #available(iOS 18.0, *) {
        controller.preferredTransition = .zoom(options: nil) { context in
          var view = LinkZoomTransitionsSourceRepository.sharedRepository.getSource(
            identifier: self.zoomTransitionSourceIdentifier)
          if let linkPreviewView = view as? NativeLinkPreviewView {
              view = linkPreviewView.directChild
          }
          if view == nil {
            print(
              "[expo-router] No source view found for identifier \(self.zoomTransitionSourceIdentifier) to enable zoom transition"
            )
          }
          return view
        }
        return
      }
    } else {
      print("[expo-router] No navigation controller found to enable zoom transition")
    }
  }

  private func findViewController() -> UIViewController? {
    var responder: UIResponder? = self
    while let r = responder {
      if LinkPreviewNativeNavigationObjC.isRNScreen(r) {
        return r as? UIViewController
      }
      responder = r.next
    }
    return nil
  }
}
