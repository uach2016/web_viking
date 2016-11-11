require 'test_helper'

class ContentControllerTest < ActionDispatch::IntegrationTest
  test "should get create_domain" do
    get content_create_domain_url
    assert_response :success
  end

end
