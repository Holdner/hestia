module Ui
  # :icon (default) is the compact cycling button of the app chrome and the
  # docs header. :segmented shows the three choices at once, for a settings
  # page where the question is being asked, not glanced at: a lone 16px icon
  # was the whole content of the household settings' Theme card.
  class ThemeToggleComponent < ApplicationComponent
    VARIANTS = { icon: "icon", segmented: "segmented" }.freeze

    CHOICES = %w[light dark system].freeze

    # Lucide sun / moon / monitor, inlined like the icon variant's own copies.
    ICON_LIGHT = %(<circle cx="12" cy="12" r="4" /><path d="M12 2v2" /><path d="M12 20v2" /><path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" /><path d="M2 12h2" /><path d="M20 12h2" /><path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" />)
    ICON_DARK = %(<path d="M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401" />)
    ICON_SYSTEM = %(<rect width="20" height="14" x="2" y="3" rx="2" /><line x1="8" x2="16" y1="21" y2="21" /><line x1="12" x2="12" y1="17" y2="21" />)

    def initialize(variant: :icon)
      @variant = VARIANTS.key?(variant) ? variant : :icon
    end

    def segmented? = @variant == :segmented

    def icon_paths(choice)
      { "light" => ICON_LIGHT, "dark" => ICON_DARK, "system" => ICON_SYSTEM }.fetch(choice).html_safe
    end
  end
end
