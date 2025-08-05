require "application_system_test_case"

class CmcpsTest < ApplicationSystemTestCase
  setup do
    @cmcp = cmcps(:one)
  end

  test "visiting the index" do
    visit cmcps_url
    assert_selector "h1", text: "Cmcps"
  end

  test "should create cmcp" do
    visit cmcps_url
    click_on "New cmcp"

    fill_in "Month", with: @cmcp.month
    fill_in "Numero servicios", with: @cmcp.numero_servicios
    fill_in "Total uf", with: @cmcp.total_uf
    fill_in "Year", with: @cmcp.year
    click_on "Create Cmcp"

    assert_text "Cmcp was successfully created"
    click_on "Back"
  end

  test "should update Cmcp" do
    visit cmcp_url(@cmcp)
    click_on "Edit this cmcp", match: :first

    fill_in "Month", with: @cmcp.month
    fill_in "Numero servicios", with: @cmcp.numero_servicios
    fill_in "Total uf", with: @cmcp.total_uf
    fill_in "Year", with: @cmcp.year
    click_on "Update Cmcp"

    assert_text "Cmcp was successfully updated"
    click_on "Back"
  end

  test "should destroy Cmcp" do
    visit cmcp_url(@cmcp)
    click_on "Destroy this cmcp", match: :first

    assert_text "Cmcp was successfully destroyed"
  end
end
