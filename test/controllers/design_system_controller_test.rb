require "test_helper"

class DesignSystemControllerTest < ActionDispatch::IntegrationTest
  test "index lists every registered component" do
    get design_system_path
    assert_response :success

    DesignSystemRegistry.all.each do |entry|
      assert_includes @response.body, entry.name
    end
  end

  test "every registered component page renders" do
    DesignSystemRegistry.all.each do |entry|
      get design_system_component_path(entry.slug)
      assert_response :success, "#{entry.slug} did not render"
      assert_includes @response.body, entry.name
    end
  end

  test "colors, typography and icons pages render" do
    get design_system_colors_path
    assert_response :success

    get design_system_typography_path
    assert_response :success

    get design_system_icons_path
    assert_response :success
  end

  test "illustrations page renders the brief and all 4 slots" do
    get design_system_illustrations_path
    assert_response :success

    assert_includes @response.body, "Bloc de prompt réutilisable"
    assert_includes @response.body, "480 × 360px"
    %w[courses fridge gifts onboarding].each do |slug|
      assert_includes @response.body, slug
    end
  end

  test "materials page renders the three slots, and says where the photos go" do
    get design_system_materials_path
    assert_response :success

    assert_includes @response.body, "app/assets/images/materials/"
    # One figure per slot, found by its caption rather than by a filename:
    # the instructions paragraph also names "papier.jpg", so matching the
    # body text would pass with no slot rendered at all.
    assert_select "figure", count: DesignSystemController::MATERIAL_SLOTS.size
    DesignSystemController::MATERIAL_SLOTS.each do |slug|
      assert_select "figure figcaption", text: /\A#{Regexp.escape(slug)}\b/
    end
  end

  test "a material slot shows its photo once the file is in app/assets/images/materials" do
    get design_system_materials_path

    # The three photos are committed, so each slot must have picked its file
    # up rather than fallen back to the placeholder.
    DesignSystemController::MATERIAL_SLOTS.each do |slug|
      assert_select "figure img[src*=?]", "materials/#{slug}"
    end
  end
end
