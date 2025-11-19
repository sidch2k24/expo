import { nanoid } from 'nanoid/non-secure';
import { useMemo } from 'react';

import { RouterToolbarHost, RouterToolbarItem } from './native';
import type { RouterToolbarHostProps } from './native.types';
import { LinkMenu, LinkMenuAction } from '../link/elements';
import type { SFSymbol } from 'sf-symbols-typescript';
import { InternalLinkPreviewContext } from '../link/InternalLinkPreviewContext';
import { View, type ColorValue, type StyleProp, type ViewStyle } from 'react-native';

export const ToolbarMenu = LinkMenu;
export const ToolbarMenuAction = LinkMenuAction;
export const ToolbarButton = ({
  children,
  sf,
  onPress,
  ...rest
}: {
  children?: string;
  sf?: SFSymbol;
  tintColor?: ColorValue;
  hidesSharedBackground?: boolean;
  sharesBackground?: boolean;
  onPress?: () => void;
}) => {
  const id = useMemo(() => nanoid(), []);
  return (
    <RouterToolbarItem
      {...rest}
      onSelected={onPress}
      identifier={id}
      title={children}
      systemImageName={sf}
    />
  );
};
export const ToolbarSpacer = () => {
  const id = useMemo(() => nanoid(), []);
  return <RouterToolbarItem identifier={id} spacer />;
};
export const ToolbarCustomView = ({
  children,
  style,
  ...rest
}: {
  children: React.ReactNode;
  style?: StyleProp<
    Omit<ViewStyle, 'position' | 'inset' | 'top' | 'left' | 'right' | 'bottom' | 'flex'>
  >;
  hidesSharedBackground?: boolean;
  sharesBackground?: boolean;
}) => {
  const id = useMemo(() => nanoid(), []);
  return (
    <RouterToolbarItem {...rest} identifier={id}>
      <View style={[style, { position: 'absolute' }]}>{children}</View>
    </RouterToolbarItem>
  );
};

export const ToolbarHost = (props: RouterToolbarHostProps) => {
  // TODO: Replace InternalLinkPreviewContext with a more generic context
  return (
    <InternalLinkPreviewContext value={{ isVisible: false, href: '' }}>
      <RouterToolbarHost {...props} />
    </InternalLinkPreviewContext>
  );
};
