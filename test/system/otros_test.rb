require "application_system_test_case"

class OtrosTest < ApplicationSystemTestCase
  setup do
    @otro = otros(:one)
  end

  test "visiting the index" do
    visit otros_url
    assert_selector "h1", text: "Otros"
  end

  test "should create otro" do
    visit otros_url
    click_on "New otro"

    fill_in "Empresa", with: @otro.empresa_id
    fill_in "Month", with: @otro.month
    fill_in "N1", with: @otro.n1
    fill_in "N2", with: @otro.n2
    fill_in "Total", with: @otro.total
    fill_in "Year", with: @otro.year
    click_on "Create Otro"

    assert_text "Otro was successfully created"
    click_on "Back"
  end

  test "should update Otro" do
    visit otro_url(@otro)
    click_on "Edit this otro", match: :first

    fill_in "Empresa", with: @otro.empresa_id
    fill_in "Month", with: @otro.month
    fill_in "N1", with: @otro.n1
    fill_in "N2", with: @otro.n2
    fill_in "Total", with: @otro.total
    fill_in "Year", with: @otro.year
    click_on "Update Otro"

    assert_text "Otro was successfully updated"
    click_on "Back"
  end

  test "should destroy Otro" do
    visit otro_url(@otro)
    click_on "Destroy this otro", match: :first

    assert_text "Otro was successfully destroyed"
  end
end
