module Ui
  class ItemComponent < ApplicationComponent
    renders_one :leading
    renders_one :title
    renders_one :description
    renders_one :trailing

    # truncate: false lets title and description wrap, for an item that is a
    # choice to read (onboarding's « Créer un foyer ») rather than a row to scan.
    def initialize(href: nil, active: false, truncate: true)
      @href = href
      @active = active
      @truncate = truncate
    end
  end
end
