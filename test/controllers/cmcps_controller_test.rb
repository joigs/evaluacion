require "test_helper"

class CmcpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cmcp = cmcps(:one)
  end

  test "should get index" do
    get cmcps_url
    assert_response :success
  end

  test "should get new" do
    get new_cmcp_url
    assert_response :success
  end

  test "should create cmcp" do
    assert_difference("Cmcp.count") do
      post cmcps_url, params: { cmcp: { month: @cmcp.month, numero_servicios: @cmcp.numero_servicios, total_uf: @cmcp.total_uf, year: @cmcp.year } }
    end

    assert_redirected_to cmcp_url(Cmcp.last)
  end

  test "should show cmcp" do
    get cmcp_url(@cmcp)
    assert_response :success
  end

  test "should get edit" do
    get edit_cmcp_url(@cmcp)
    assert_response :success
  end

  test "should update cmcp" do
    patch cmcp_url(@cmcp), params: { cmcp: { month: @cmcp.month, numero_servicios: @cmcp.numero_servicios, total_uf: @cmcp.total_uf, year: @cmcp.year } }
    assert_redirected_to cmcp_url(@cmcp)
  end

  test "should destroy cmcp" do
    assert_difference("Cmcp.count", -1) do
      delete cmcp_url(@cmcp)
    end

    assert_redirected_to cmcps_url
  end
end
