# frozen_string_literal: true

module KeystoneUi
  module SurfaceColors
    # Maps surface color families to Tailwind class tokens.
    # Components call SurfaceColors[:token] to get the right classes.
    PALETTE = {
      zinc: {
        card_border: "border-gray-200 dark:border-zinc-700",
        card_bg: "bg-white dark:bg-zinc-800",
        subtle_bg: "bg-gray-50 dark:bg-zinc-800",
        heading: "text-gray-900 dark:text-white",
        body: "text-gray-500 dark:text-gray-400",
        muted: "text-gray-600 dark:text-gray-400",
        icon: "text-gray-400"
      },
      slate: {
        card_border: "border-slate-200 dark:border-slate-700",
        card_bg: "bg-white dark:bg-slate-800",
        subtle_bg: "bg-slate-50 dark:bg-slate-800",
        heading: "text-slate-900 dark:text-white",
        body: "text-slate-500 dark:text-slate-400",
        muted: "text-slate-600 dark:text-slate-400",
        icon: "text-slate-400"
      },
      gray: {
        card_border: "border-gray-200 dark:border-gray-700",
        card_bg: "bg-white dark:bg-gray-800",
        subtle_bg: "bg-gray-50 dark:bg-gray-800",
        heading: "text-gray-900 dark:text-white",
        body: "text-gray-500 dark:text-gray-400",
        muted: "text-gray-600 dark:text-gray-400",
        icon: "text-gray-400"
      },
      neutral: {
        card_border: "border-neutral-200 dark:border-neutral-700",
        card_bg: "bg-white dark:bg-neutral-800",
        subtle_bg: "bg-neutral-50 dark:bg-neutral-800",
        heading: "text-neutral-900 dark:text-white",
        body: "text-neutral-500 dark:text-neutral-400",
        muted: "text-neutral-600 dark:text-neutral-400",
        icon: "text-neutral-400"
      },
      stone: {
        card_border: "border-stone-200 dark:border-stone-700",
        card_bg: "bg-white dark:bg-stone-800",
        subtle_bg: "bg-stone-50 dark:bg-stone-800",
        heading: "text-stone-900 dark:text-white",
        body: "text-stone-500 dark:text-stone-400",
        muted: "text-stone-600 dark:text-stone-400",
        icon: "text-stone-400"
      }
    }.freeze

    def self.current
      PALETTE.fetch(KeystoneUi.configuration.surface)
    end

    def self.[](key)
      current.fetch(key)
    end
  end
end
