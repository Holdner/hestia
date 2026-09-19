require "test_helper"

class Ui::FilterChipComponentTest < ViewComponent::TestCase
  test "the whole chip height is the filter link" do
    render_inline(Ui::FilterChipComponent.new(label: "Amis", href: "/contacts?tag_id=1"))

    assert_selector "span.h-8 > a.h-full[href='/contacts?tag_id=1']", text: "Amis"
    refute_selector "a[aria-current]"
  end

  test "the active filter is filled and marked current" do
    render_inline(Ui::FilterChipComponent.new(label: "Tous", href: "/contacts", active: true))

    assert_selector "span.bg-button-primary a[aria-current='true']", text: "Tous"
  end

  test "renders a colour dot and the given actions" do
    render_inline(Ui::FilterChipComponent.new(label: "Factures", href: "/documents?folder_id=2", dot_class: "bg-blue-500")) do |chip|
      chip.with_action { "EDIT" }
      chip.with_action { "DELETE" }
    end

    assert_selector "a span.size-2.rounded-full.bg-blue-500[aria-hidden='true']"
    assert_text "EDIT"
    assert_text "DELETE"
  end
end
