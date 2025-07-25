require "test_helper"

class AldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ald = alds(:one)
  end

  test "should get index" do
    get alds_url
    assert_response :success
  end

  test "should get new" do
    get new_ald_url
    assert_response :success
  end

  test "should create ald" do
    assert_difference("Ald.count") do
      post alds_url, params: { ald: { empresa_id: @ald.empresa_id, month: @ald.month, n1: @ald.n1, n2: @ald.n2, total: @ald.total, year: @ald.year } }
    end

    assert_redirected_to ald_url(Ald.last)
  end

  test "should show ald" do
    get ald_url(@ald)
    assert_response :success
  end

  test "should get edit" do
    get edit_ald_url(@ald)
    assert_response :success
  end

  test "should update ald" do
    patch ald_url(@ald), params: { ald: { empresa_id: @ald.empresa_id, month: @ald.month, n1: @ald.n1, n2: @ald.n2, total: @ald.total, year: @ald.year } }
    assert_redirected_to ald_url(@ald)
  end

  test "should destroy ald" do
    assert_difference("Ald.count", -1) do
      delete ald_url(@ald)
    end

    assert_redirected_to alds_url
  end
end
