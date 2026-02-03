// dpp.vim TypeScript Configuration

import type {
  ContextBuilder,
  ExtOptions,
  Plugin,
  ProtocolName,
} from "jsr:@shougo/dpp-vim@5/types";
import {
  BaseConfig,
  type ConfigReturn,
} from "jsr:@shougo/dpp-vim@5/config";
import { Protocol } from "jsr:@shougo/dpp-vim@5/protocol";

import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@1";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "jsr:@shougo/dpp-ext-lazy@1";

import type { Denops } from "jsr:@denops/std@8";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
  }): Promise<ConfigReturn> {
    // Set global options
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      ProtocolName,
      Protocol
    >;

    const recordPlugins: Record<string, Plugin> = {};

    // Load TOML extension
    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.denops.dispatcher.getExt(
      "toml",
    ) as [TomlExt | undefined, ExtOptions, TomlParams];

    if (tomlExt) {
      const action = tomlExt.actions.load;

      // Load dpp.toml (immediate load)
      const toml = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: tomlOptions,
        extParams: tomlParams,
        actionParams: {
          path: "$BASE_DIR/dpp.toml",
          options: {
            lazy: false,
          },
        },
      });

      for (const plugin of toml.plugins ?? []) {
        recordPlugins[plugin.name] = plugin;
      }

      // Load dpp_lazy.toml (lazy load)
      const lazyToml = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: tomlOptions,
        extParams: tomlParams,
        actionParams: {
          path: "$BASE_DIR/dpp_lazy.toml",
          options: {
            lazy: true,
          },
        },
      });

      for (const plugin of lazyToml.plugins ?? []) {
        recordPlugins[plugin.name] = plugin;
      }
    }

    // Apply lazy loading with dpp-ext-lazy
    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.denops.dispatcher.getExt(
      "lazy",
    ) as [LazyExt | undefined, ExtOptions, LazyParams];

    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    return {
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
