import ExpoModulesCore
import UIKit

class RouterToolbarHostView: ExpoView, LinkPreviewMenuUpdatable {
  // Mutable map of toolbar items
  var toolbarItemsArray: [String] = []
  var toolbarItemsMap: [String: RouterToolbarItemView] = [:]
  var menuItemsMap: [String: LinkPreviewNativeActionView] = [:]

  private func addRouterToolbarItemAtIndex(
    _ item: RouterToolbarItemView,
    index: Int
  ) {
    let identifier = item.identifier
    toolbarItemsArray.insert(identifier, at: index)
    toolbarItemsMap[identifier] = item
    item.host = self
  }

  private func addMenuToolbarItemAtIndex(
    _ item: LinkPreviewNativeActionView,
    index: Int
  ) {
    let identifier = item.identifier
    toolbarItemsArray.insert(identifier, at: index)
    menuItemsMap[identifier] = item
  }

  private func removeToolbarItemWithId(_ id: String) {
    if let index = toolbarItemsArray.firstIndex(of: id) {
      toolbarItemsArray.remove(at: index)
      toolbarItemsMap.removeValue(forKey: id)
      menuItemsMap.removeValue(forKey: id)
    }
  }

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }

  func updateToolbarItem(withId id: String) {
    if let controller = self.findViewController() {
      let index = toolbarItemsArray.firstIndex(of: id)
      if let index = index, let item = toolbarItemsMap[id] {
        controller.toolbarItems?[index] = item.barButtonItem
      }
    }
  }

  func updateToolbarItems() {
    if let controller = self.findViewController() {
      if #available(iOS 18.0, *) {
        print(
          "Updating toolbar items in RouterToolbarHost \(toolbarItemsArray.count) items"
        )
        controller.setToolbarItems(
          toolbarItemsArray.compactMap {
            if let item = toolbarItemsMap[$0] {
              return item.barButtonItem
            } else if let menu = menuItemsMap[$0] {
              return UIBarButtonItem(
                title: menu.title,
                image: menu.icon.flatMap { UIImage(systemName: $0) },
                primaryAction: nil,
                menu: menu.uiAction as? UIMenu
              )
            } else {
              print(
                "[expo-router] Warning: Could not find toolbar item or menu for identifier \($0)"
              )
              return nil
            }
          }, animated: true)
        controller.navigationController?.setToolbarHidden(
          false, animated: false)
        return
      }
    } else {
      print(
        "[expo-router] Warning: Could not find owning UIViewController for RouterToolbarHostView")
    }
  }

  override func mountChildComponentView(_ childComponentView: UIView, index: Int) {
    if let toolbarItem = childComponentView as? RouterToolbarItemView {
      if toolbarItem.identifier.isEmpty {
        print("[expo-router] RouterToolbarItemView identifier is empty")
        return
      }
      addRouterToolbarItemAtIndex(toolbarItem, index: index)
    } else if let menu = childComponentView as? LinkPreviewNativeActionView {
      addMenuToolbarItemAtIndex(menu, index: index)
    } else {
      print(
        "ExpoRouter: Unknown child component view (\(childComponentView)) mounted to RouterToolbarHost"
      )
    }
    updateToolbarItems()
  }

  override func unmountChildComponentView(_ childComponentView: UIView, index: Int) {
    if let toolbarItem = childComponentView as? RouterToolbarItemView {
      if toolbarItem.identifier.isEmpty {
        print("[expo-router] RouterToolbarItemView identifier is empty")
        return
      }
      removeToolbarItemWithId(toolbarItem.identifier)
    } else if let menu = childComponentView as? LinkPreviewNativeActionView {
      if menu.identifier.isEmpty {
        print("[expo-router] Menu identifier is empty")
        return
      }
      removeToolbarItemWithId(menu.identifier)
    } else {
      print(
        "ExpoRouter: Unknown child component view (\(childComponentView)) unmounted from RouterToolbarHost"
      )
    }
    updateToolbarItems()
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    // Update toolbar items when the view is added to the window
    updateToolbarItems()
  }

  func updateMenu() {
    updateToolbarItems()
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

class RouterToolbarItemView: ExpoView {
  var identifier: String = ""
  var type: String? {
    didSet {
      if type != oldValue {
        self.performUpdate()
      }
    }
  }
  var title: String? {
    didSet {
      if title != oldValue {
        self.performUpdate()
      }
    }
  }
  var systemImageName: String? {
    didSet {
      if systemImageName != oldValue {
        self.performUpdate()
      }
    }
  }
  var customView: UIView? {
    didSet {
      if customView != oldValue {
        self.performUpdate()
      }
    }
  }
  var customTintColor: UIColor? {
    didSet {
      if customTintColor != oldValue {
        self.performUpdate()
      }
    }
  }
  var hidesSharedBackground: Bool = false {
    didSet {
      if hidesSharedBackground != oldValue {
        self.performUpdate()
      }
    }
  }
  var sharesBackground: Bool = true {
    didSet {
      if sharesBackground != oldValue {
        self.performUpdate()
      }
    }
  }
  var host: RouterToolbarHostView?

  let onSelected = EventDispatcher()

  func performUpdate() {
    self.host?.updateToolbarItem(withId: self.identifier)
  }

  @objc func handleAction() {
    onSelected()
  }

  var barButtonItem: UIBarButtonItem {
    var item = UIBarButtonItem()
    if let customView = customView {
      item = UIBarButtonItem(customView: customView)
    } else if type == "spacer" {
      item = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    } else {

      if let title = title {
        item.title = title
      }
      if let systemImageName = systemImageName {
        item.image = UIImage(systemName: systemImageName)
      }
      if let tintColor = customTintColor {
        item.tintColor = tintColor
      }
    }
    if #available(iOS 26.0, *) {
      item.hidesSharedBackground = hidesSharedBackground
      item.sharesBackground = sharesBackground
    }
    item.target = self
    item.action = #selector(handleAction)
    return item
  }

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
  }

  override func mountChildComponentView(_ childComponentView: UIView, index: Int) {
    if customView != nil {
      print(
        "[expo-router] Warning: RouterToolbarItemView can only have one child view"
      )
      return
    }
    customView = childComponentView
    performUpdate()
  }

  override func unmountChildComponentView(_ childComponentView: UIView, index: Int) {
    if customView == childComponentView {
      childComponentView.removeFromSuperview()
      customView = nil
      performUpdate()
    }
  }
}

/**
titleStyle?: {
    fontFamily?: string;
    fontSize?: number;
    fontWeight?: string;
    color?: ColorValue;
  };
  variant?: 'plain' | 'done' | 'prominent';
  hidesSharedBackground?: boolean;
  sharesBackground?: boolean;
  destructive?: boolean;
  badge?: {
    /**
     * The text to display in the badge.
     */
    value: string;
    /**
     * Style of the badge.
     */
    style?: {
      color?: ColorValue;
      backgroundColor?: ColorValue;
      fontFamily?: string;
      fontSize?: number;
      fontWeight?: string;
    };
  };
  */
