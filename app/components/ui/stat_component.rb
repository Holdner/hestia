module Ui
  # A headline figure: a label, the amount itself in the editorial serif
  # (.hero-amount), and optionally the supporting figure under it
  # (« sur 1 600,00 € prévus · 12 jours restants ») in pine, a badge beside
  # the label and a gauge at the bottom.
  #
  # Content only, no container of its own: it sits in a Card, or straight on
  # the page. Giving it a border would put a card inside a card the moment a
  # caller wraps it (rule 4, one elevation level at a time).
  class StatComponent < ApplicationComponent
    renders_one :support
    renders_one :badge
    renders_one :gauge

    def initialize(label:, value:, class_name: nil)
      @label = label
      @value = value
      @class_name = class_name
    end
  end
end
