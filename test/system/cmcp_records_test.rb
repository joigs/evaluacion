require "application_system_test_case"

class CmcpRecordsTest < ApplicationSystemTestCase
  setup do
    @cmcp_record = cmcp_records(:one)
  end

  test "visiting the index" do
    visit cmcp_records_url
    assert_selector "h1", text: "Cmcp records"
  end

  test "should create cmcp record" do
    visit cmcp_records_url
    click_on "New cmcp record"

    fill_in "Cmcp", with: @cmcp_record.cmcp_id
    fill_in "Fecha", with: @cmcp_record.fecha
    fill_in "Numero", with: @cmcp_record.numero
    fill_in "Suma", with: @cmcp_record.suma
    click_on "Create Cmcp record"

    assert_text "Cmcp record was successfully created"
    click_on "Back"
  end

  test "should update Cmcp record" do
    visit cmcp_record_url(@cmcp_record)
    click_on "Edit this cmcp record", match: :first

    fill_in "Cmcp", with: @cmcp_record.cmcp_id
    fill_in "Fecha", with: @cmcp_record.fecha
    fill_in "Numero", with: @cmcp_record.numero
    fill_in "Suma", with: @cmcp_record.suma
    click_on "Update Cmcp record"

    assert_text "Cmcp record was successfully updated"
    click_on "Back"
  end

  test "should destroy Cmcp record" do
    visit cmcp_record_url(@cmcp_record)
    click_on "Destroy this cmcp record", match: :first

    assert_text "Cmcp record was successfully destroyed"
  end
end
