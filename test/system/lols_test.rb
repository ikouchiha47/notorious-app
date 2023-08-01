require "application_system_test_case"

class LolsTest < ApplicationSystemTestCase
  setup do
    @lol = lols(:one)
  end

  test "visiting the index" do
    visit lols_url
    assert_selector "h1", text: "Lols"
  end

  test "should create lol" do
    visit lols_url
    click_on "New lol"

    click_on "Create Lol"

    assert_text "Lol was successfully created"
    click_on "Back"
  end

  test "should update Lol" do
    visit lol_url(@lol)
    click_on "Edit this lol", match: :first

    click_on "Update Lol"

    assert_text "Lol was successfully updated"
    click_on "Back"
  end

  test "should destroy Lol" do
    visit lol_url(@lol)
    click_on "Destroy this lol", match: :first

    assert_text "Lol was successfully destroyed"
  end
end
