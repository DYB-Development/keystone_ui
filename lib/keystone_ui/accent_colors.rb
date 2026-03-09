# frozen_string_literal: true

module KeystoneUi
  module AccentColors
    # Maps accent names to Tailwind class fragments for each usage context.
    # Components call AccentColors.classes_for(:context) to get the right classes.
    PALETTE = {
      blue: {
        border: "border-blue-500/20",
        bg: "bg-blue-500/10",
        text: "text-blue-600",
        dark_text: "dark:text-blue-400",
        hover_border: "hover:border-blue-500/50",
        hover_text: "hover:text-blue-600",
        dark_hover_text: "dark:hover:text-blue-400"
      },
      emerald: {
        border: "border-emerald-500/20",
        bg: "bg-emerald-500/10",
        text: "text-emerald-600",
        dark_text: "dark:text-emerald-400",
        hover_border: "hover:border-emerald-500/50",
        hover_text: "hover:text-emerald-600",
        dark_hover_text: "dark:hover:text-emerald-400"
      },
      cyan: {
        border: "border-cyan-500/20",
        bg: "bg-cyan-500/10",
        text: "text-cyan-600",
        dark_text: "dark:text-cyan-400",
        hover_border: "hover:border-cyan-500/50",
        hover_text: "hover:text-cyan-600",
        dark_hover_text: "dark:hover:text-cyan-400"
      },
      indigo: {
        border: "border-indigo-500/20",
        bg: "bg-indigo-500/10",
        text: "text-indigo-600",
        dark_text: "dark:text-indigo-400",
        hover_border: "hover:border-indigo-500/50",
        hover_text: "hover:text-indigo-600",
        dark_hover_text: "dark:hover:text-indigo-400"
      },
      violet: {
        border: "border-violet-500/20",
        bg: "bg-violet-500/10",
        text: "text-violet-600",
        dark_text: "dark:text-violet-400",
        hover_border: "hover:border-violet-500/50",
        hover_text: "hover:text-violet-600",
        dark_hover_text: "dark:hover:text-violet-400"
      },
      rose: {
        border: "border-rose-500/20",
        bg: "bg-rose-500/10",
        text: "text-rose-600",
        dark_text: "dark:text-rose-400",
        hover_border: "hover:border-rose-500/50",
        hover_text: "hover:text-rose-600",
        dark_hover_text: "dark:hover:text-rose-400"
      }
    }.freeze

    def self.current
      PALETTE.fetch(KeystoneUi.configuration.accent)
    end

    def self.[](key)
      current.fetch(key)
    end
  end
end
