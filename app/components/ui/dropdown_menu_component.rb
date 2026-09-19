module Ui
  class DropdownMenuComponent < ApplicationComponent
    renders_one :trigger

    # Two ways to fill it:
    #
    # * items: [["Label", "value"], :separator, ...] for a menu that only
    #   reports a choice: picking one dispatches dropdown-menu:select with the
    #   value, for a Stimulus controller to act on.
    # * a block of actions, for a menu whose entries DO something on the
    #   server (archive, convert, delete: button_to forms, links). Each entry
    #   takes .item_options so it looks like, and is reached by the arrow keys
    #   like, a generated item; .separator draws the rule between groups.
    ITEM_CLASSES = "flex w-full cursor-pointer items-center gap-2 whitespace-nowrap rounded-md px-2 py-1.5 text-left text-sm text-primary " \
      "hover:bg-surface-hover focus:bg-surface-hover focus:outline-none".freeze

    def self.item_options(destructive: false)
      {
        role: "menuitem", tabindex: "-1", data: { dropdown_menu_target: "item" },
        class: [ ITEM_CLASSES, ("text-destructive" if destructive) ].compact.join(" ")
      }
    end

    def self.separator
      ActionController::Base.helpers.tag.div(class: "my-1 h-px bg-tertiary", role: "separator")
    end

    def initialize(items: [])
      @items = items
      @panel_id = "dropdown-menu-#{SecureRandom.hex(4)}"
    end
  end
end
