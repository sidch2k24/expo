export declare const Toolbar: ((props: import("./native.types").RouterToolbarHostProps) => import("react").JSX.Element) & {
    Menu: import("react").FC<import("..").LinkMenuProps>;
    MenuAction: typeof import("..").LinkMenuAction;
    Button: ({ children, sf, onPress, ...rest }: {
        children?: string;
        sf?: import("sf-symbols-typescript").SFSymbol;
        tintColor?: import("react-native").ColorValue;
        hidesSharedBackground?: boolean;
        sharesBackground?: boolean;
        onPress?: () => void;
    }) => import("react").JSX.Element;
    Spacer: () => import("react").JSX.Element;
    CustomView: ({ children, style, ...rest }: {
        children: React.ReactNode;
        style?: import("react-native").StyleProp<Omit<import("react-native").ViewStyle, "position" | "inset" | "top" | "left" | "right" | "bottom" | "flex">>;
        hidesSharedBackground?: boolean;
        sharesBackground?: boolean;
    }) => import("react").JSX.Element;
};
//# sourceMappingURL=index.d.ts.map