require "test_helper"

class Ui::ThemeToggleComponentTest < ViewComponent::TestCase
  test "renders an icon-only button with an accessible label" do
    render_inline(Ui::ThemeToggleComponent.new)

    assert_selector "button[type='button'][aria-label]"
  end

  test "the accessible label announces the currently active theme (light, by default before JS hydrates)" do
    render_inline(Ui::ThemeToggleComponent.new)

    assert_selector "button[aria-label='Thème actuel : clair. Cliquer pour changer de thème.']"
  end

  test "wires the button to the theme controller's cycle action" do
    render_inline(Ui::ThemeToggleComponent.new)

    assert_selector "button[data-controller='theme'][data-action='click->theme#cycle']"
  end

  test "renders light/dark/system icon options, with only light visible by default" do
    render_inline(Ui::ThemeToggleComponent.new)

    assert_selector "span[data-theme-target='option'][data-theme='light']:not([hidden])"
    assert_selector "span[data-theme-target='option'][data-theme='dark'][hidden]", visible: false
    assert_selector "span[data-theme-target='option'][data-theme='system'][hidden]", visible: false
    assert_selector "svg", count: 3, visible: false
  end

  test "the segmented variant shows the three choices as pressable buttons wired to choose" do
    I18n.with_locale(:fr) { render_inline(Ui::ThemeToggleComponent.new(variant: :segmented)) }

    assert_selector "div[role='group'][data-controller='theme']"
    %w[light dark system].each do |choice|
      assert_selector "button[data-theme-target='choice'][data-theme-choice-param='#{choice}'][data-action='click->theme#choose'][aria-pressed='false']"
    end
    assert_selector "button", text: "Sombre"
  end
end
