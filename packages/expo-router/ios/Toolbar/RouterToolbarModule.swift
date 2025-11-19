import ExpoModulesCore

public class RouterToolbarModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoRouterToolbarModule")

    View(RouterToolbarHostView.self) {
      Prop("disableForceFlatten") { (v: RouterToolbarHostView, d: Bool) in
        // This prop is used in ExpoShadowNode in order to disable force flattening, when display: contents is used
      }
    }
    View(RouterToolbarItemView.self) {
      Prop("identifier") { (view: RouterToolbarItemView, identifier: String) in
        view.identifier = identifier
      }
      Prop("type") { (view: RouterToolbarItemView, type: String) in
        view.type = type
      }
      Prop("title") { (view: RouterToolbarItemView, title: String?) in
        view.title = title
      }
      Prop("systemImageName") { (view: RouterToolbarItemView, systemImageName: String?) in
        view.systemImageName = systemImageName
      }
      Prop("tintColor") { (view: RouterToolbarItemView, tintColor: UIColor?) in
        view.customTintColor = tintColor
      }
      Prop("hidesSharedBackground") { (view: RouterToolbarItemView, hidesSharedBackground: Bool) in
        view.hidesSharedBackground = hidesSharedBackground
      }
      Prop("sharesBackground") { (view: RouterToolbarItemView, sharesBackground: Bool) in
        view.sharesBackground = sharesBackground
      }
      Prop("disableForceFlatten") { (v: RouterToolbarItemView, d: Bool) in
        // This prop is used in ExpoShadowNode in order to disable force flattening, when display: contents is used
      }

      Events("onSelected")
    }
  }
}
