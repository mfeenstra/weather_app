require "application_system_test_case"

class MetricsTest < ApplicationSystemTestCase
  setup do
    @metric = metrics(:one)
  end

  test "visiting the index" do
    visit metrics_url
    assert_selector "h1", text: "Metrics"
  end

  test "should create metric" do
    visit metrics_url
    click_on "New metric"

    fill_in "Day", with: @metric.day
    fill_in "Location", with: @metric.location_id
    fill_in "Max", with: @metric.max
    fill_in "Min", with: @metric.min
    fill_in "Temp", with: @metric.temp
    fill_in "Zipcode", with: @metric.zipcode
    click_on "Create Metric"

    assert_text "Metric was successfully created"
    click_on "Back"
  end

  test "should update Metric" do
    visit metric_url(@metric)
    click_on "Edit this metric", match: :first

    fill_in "Day", with: @metric.day
    fill_in "Location", with: @metric.location_id
    fill_in "Max", with: @metric.max
    fill_in "Min", with: @metric.min
    fill_in "Temp", with: @metric.temp
    fill_in "Zipcode", with: @metric.zipcode
    click_on "Update Metric"

    assert_text "Metric was successfully updated"
    click_on "Back"
  end

  test "should destroy Metric" do
    visit metric_url(@metric)
    click_on "Destroy this metric", match: :first

    assert_text "Metric was successfully destroyed"
  end
end
