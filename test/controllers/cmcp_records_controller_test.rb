require "test_helper"

class CmcpRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cmcp_record = cmcp_records(:one)
  end

  test "should get index" do
    get cmcp_records_url
    assert_response :success
  end

  test "should get new" do
    get new_cmcp_record_url
    assert_response :success
  end

  test "should create cmcp_record" do
    assert_difference("CmcpRecord.count") do
      post cmcp_records_url, params: { cmcp_record: { cmcp_id: @cmcp_record.cmcp_id, fecha: @cmcp_record.fecha, numero: @cmcp_record.numero, suma: @cmcp_record.suma } }
    end

    assert_redirected_to cmcp_record_url(CmcpRecord.last)
  end

  test "should show cmcp_record" do
    get cmcp_record_url(@cmcp_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_cmcp_record_url(@cmcp_record)
    assert_response :success
  end

  test "should update cmcp_record" do
    patch cmcp_record_url(@cmcp_record), params: { cmcp_record: { cmcp_id: @cmcp_record.cmcp_id, fecha: @cmcp_record.fecha, numero: @cmcp_record.numero, suma: @cmcp_record.suma } }
    assert_redirected_to cmcp_record_url(@cmcp_record)
  end

  test "should destroy cmcp_record" do
    assert_difference("CmcpRecord.count", -1) do
      delete cmcp_record_url(@cmcp_record)
    end

    assert_redirected_to cmcp_records_url
  end
end
