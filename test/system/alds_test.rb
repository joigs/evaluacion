require "application_system_test_case"

class AldsTest < ApplicationSystemTestCase
  setup do
    @ald = alds(:one)
  end

  test "visiting the index" do
    visit alds_url
    assert_selector "h1", text: "Alds"
  end

  test "should create ald" do
    visit alds_url
    click_on "New ald"

    fill_in "Empresa", with: @ald.empresa_id
    fill_in "Month", with: @ald.month
    fill_in "N1", with: @ald.n1
    fill_in "N2", with: @ald.n2
    fill_in "Total", with: @ald.total
    fill_in "Year", with: @ald.year
    click_on "Create Ald"

    assert_text "Ald was successfully created"
    click_on "Back"
  end

  test "should update Ald" do
    visit ald_url(@ald)
    click_on "Edit this ald", match: :first

    fill_in "Empresa", with: @ald.empresa_id
    fill_in "Month", with: @ald.month
    fill_in "N1", with: @ald.n1
    fill_in "N2", with: @ald.n2
    fill_in "Total", with: @ald.total
    fill_in "Year", with: @ald.year
    click_on "Update Ald"

    assert_text "Ald was successfully updated"
    click_on "Back"
  end

  test "should destroy Ald" do
    visit ald_url(@ald)
    click_on "Destroy this ald", match: :first

    assert_text "Ald was successfully destroyed"
  end
end
