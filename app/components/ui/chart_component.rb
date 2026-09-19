module Ui
  # Minimal dependency-free bar chart. For richer charts, render real data through
  # a JS charting lib via a dedicated Stimulus controller instead of extending this.
  class ChartComponent < ApplicationComponent
    # Rotating categorical palette — module accent tokens, not raw Tailwind
    # colors, so bars adapt in dark mode and never render the old hardcoded
    # indigo brand color (#444CE7). Only for categorical: true (see below).
    COLORS = %w[bg-module-tasks bg-module-recipes bg-module-fridge bg-module-wellbeing bg-module-gifts].freeze

    # data: [["Jan", 42], ["Feb", 73], ...]
    # variant: :bar (default) or :line — line draws a single-series SVG polyline
    # through currentColor, the convention shared with lucide_icon.
    #
    # A single series is neutral: every bar (and the line) in pine, --gauge,
    # the counterpoint that informs without asking for action. A pool's pH day
    # after day used to rotate through five colors, as if each day were its own
    # category. categorical: true is for bars that ARE categories (the Budget's
    # expense breakdown); color: still tints a line with a module accent.
    def initialize(data: [], height: 160, variant: :bar, color: nil, categorical: false)
      @data = data
      @height = height
      @variant = variant
      @color = color
      @categorical = categorical
      values = data.map { |(_, v)| v }
      @max = values.max.to_f.nonzero? || 1
      @min = [ values.min.to_f, 0 ].min
    end

    def line?
      @variant == :line
    end

    def color_class
      @color ? "text-module-#{@color}" : "text-gauge"
    end

    def bar_color(index)
      @categorical ? COLORS[index % COLORS.size] : "bg-gauge"
    end

    def line_points
      return "" if @data.size < 2

      range = (@max - @min).nonzero? || 1
      step = 100.0 / (@data.size - 1)
      @data.each_with_index.map do |(_, value), index|
        x = (index * step).round(2)
        y = (100 - ((value - @min) / range * 100)).round(2)
        "#{x},#{y}"
      end.join(" ")
    end
  end
end
