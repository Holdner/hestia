require "test_helper"

class Ui::StatComponentTest < ViewComponent::TestCase
  test "renders the label and the value as a hero amount" do
    render_inline(Ui::StatComponent.new(label: "Revenus", value: "2 400 €"))

    assert_selector "p.text-secondary", text: "Revenus"
    assert_selector "p.hero-amount", text: "2 400 €"
  end

  test "renders the supporting figure in its own color when given" do
    render_inline(Ui::StatComponent.new(label: "Budget d'août", value: "1 284,90 €")) do |c|
      c.with_support { "sur 1 600,00 € prévus" }
    end

    assert_selector "p.text-support-figure", text: "sur 1 600,00 € prévus"
  end

  test "renders neither supporting figure, badge nor gauge when not given" do
    render_inline(Ui::StatComponent.new(label: "Revenus", value: "2 400 €"))

    refute_selector ".text-support-figure"
    refute_selector ".max-w-full"
    refute_selector ".mt-3"
  end

  test "renders a badge beside the label and a gauge at the bottom" do
    # In the view context, so the gauge slot can render a component of its own.
    render_in_view_context do
      render(Ui::StatComponent.new(label: "Reste à vivre", value: "400 €")) do |c|
        c.with_badge { "13 %" }
        c.with_gauge { render(Ui::ProgressComponent.new(value: 13)) }
      end
    end

    assert_selector ".max-w-full", text: "13 %"
    assert_selector ".mt-3 div[role='progressbar'][aria-valuenow='13']"
  end

  test "draws no container of its own" do
    render_inline(Ui::StatComponent.new(label: "Revenus", value: "2 400 €", class_name: "my-stat"))

    assert_selector "div.my-stat"
    refute_selector ".border, .rounded-lg, .bg-container"
  end
end
