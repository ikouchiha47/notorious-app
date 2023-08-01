require "test_helper"

class LolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lol = lols(:one)
  end

  test "should get index" do
    get lols_url
    assert_response :success
  end

  test "should get new" do
    get new_lol_url
    assert_response :success
  end

  test "should create lol" do
    assert_difference("Lol.count") do
      post lols_url, params: { lol: {  } }
    end

    assert_redirected_to lol_url(Lol.last)
  end

  test "should show lol" do
    get lol_url(@lol)
    assert_response :success
  end

  test "should get edit" do
    get edit_lol_url(@lol)
    assert_response :success
  end

  test "should update lol" do
    patch lol_url(@lol), params: { lol: {  } }
    assert_redirected_to lol_url(@lol)
  end

  test "should destroy lol" do
    assert_difference("Lol.count", -1) do
      delete lol_url(@lol)
    end

    assert_redirected_to lols_url
  end
end
