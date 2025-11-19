import type { ColorValue } from 'react-native';
import type { SFSymbol } from 'sf-symbols-typescript';
export interface RouterToolbarHostProps {
    children?: React.ReactNode;
}
export interface RouterToolbarItemProps {
    children?: React.ReactNode;
    identifier: string;
    title?: string;
    systemImageName?: SFSymbol;
    spacer?: boolean;
    tintColor?: ColorValue;
    hidesSharedBackground?: boolean;
    sharesBackground?: boolean;
    onSelected?: () => void;
}
//# sourceMappingURL=native.types.d.ts.map