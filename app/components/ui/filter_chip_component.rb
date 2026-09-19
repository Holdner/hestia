module Ui
  # One filter of a chip strip (contact tags, document folders, provider
  # types): a pill whose whole height is the link, an optional colour dot, and
  # optional small actions (edit, delete) inside it.
  #
  # It replaces a Badge with a link dropped into it. The Badge is a label, 20px
  # tall, so the link in it was a 17px target, and each of the three strips had
  # grown its own actions at their own sizes (a 40px ghost button next to a
  # 12px pencil in the same chip).
  #
  # 32px tall, actions at ACTION_CLASSES' 24px: the WCAG AA floor a chip strip
  # declares with data-touch-target="compact" (see measure.js touchFloorFor).
  class FilterChipComponent < ApplicationComponent
    renders_many :actions

    ACTION_CLASSES = "inline-flex size-6 shrink-0 cursor-pointer items-center justify-center rounded-full " \
      "opacity-70 transition-opacity hover:opacity-100 focus-visible:ring-focus".freeze

    def initialize(label:, href:, active: false, dot_class: nil)
      @label = label
      @href = href
      @active = active
      @dot_class = dot_class
    end
  end
end
