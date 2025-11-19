import type { RouterToolbarHostProps } from './native.types';
import { LinkMenuAction } from '../link/elements';
import type { SFSymbol } from 'sf-symbols-typescript';
import { type ColorValue, type StyleProp, type ViewStyle } from 'react-native';
export declare const ToolbarMenu: import("react").FC<import("../link/elements").LinkMenuProps>;
export declare const ToolbarMenuAction: typeof LinkMenuAction;
export declare const ToolbarButton: ({ children, sf, onPress, ...rest }: {
    children?: string;
    sf?: SFSymbol;
    tintColor?: ColorValue;
    hidesSharedBackground?: boolean;
    sharesBackground?: boolean;
    onPress?: () => void;
}) => import("react").JSX.Element;
export declare const ToolbarSpacer: () => import("react").JSX.Element;
export declare const ToolbarCustomView: ({ children, style, ...rest }: {
    children: React.ReactNode;
    style?: StyleProp<Omit<ViewStyle, "position" | "inset" | "top" | "left" | "right" | "bottom" | "flex">>;
    hidesSharedBackground?: boolean;
    sharesBackground?: boolean;
}) => import("react").JSX.Element;
export declare const ToolbarHost: (props: RouterToolbarHostProps) => import("react").JSX.Element;
//# sourceMappingURL=elements.d.ts.map