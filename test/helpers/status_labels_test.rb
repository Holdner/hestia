require "test_helper"

# A status the model returns but the locale doesn't know renders as its
# humanized key: Vehicle#inspection_status and Perishable#expiration_status
# once returned :destructive (the badge variant's name, not a status), and the
# dashboard showed a badge reading « Destructive » in both languages.
class StatusLabelsTest < ActionView::TestCase
  include VehiclesHelper
  include FridgeHelper

  test "every inspection status a vehicle can return has a label and a badge variant" do
    statuses = [ nil, -1, 10, 60, 200 ].map do |days|
      Vehicle.new(inspection_expires_on: days && Date.current + days).inspection_status
    end

    assert_equal VehiclesHelper::INSPECTION_BADGE_VARIANTS.keys.sort, statuses.uniq.sort
    assert_labelled statuses, "vehicles.inspection_statuses"
  end

  test "every expiration status a perishable can return has a label and a badge variant" do
    statuses = [ nil, -1, 0, 2, 10 ].map do |days|
      FridgeItem.new(expires_on: days && Date.current + days).expiration_status
    end

    assert_equal FridgeHelper::EXPIRATION_BADGE_VARIANTS.keys.sort, statuses.uniq.sort
    assert_labelled statuses, "fridge.expiration"
  end

  private
    def assert_labelled(statuses, scope)
      %i[fr en].each do |locale|
        statuses.each do |status|
          assert I18n.exists?("#{scope}.#{status}", locale), "#{scope}.#{status} is missing in #{locale}"
        end
      end
    end
end
