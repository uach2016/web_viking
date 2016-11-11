
require 'rest_client'
require 'json'

class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
  end

  def uninstall
	access_token = 'secret'
	revoke_url   = 'https://app.myshopify.com/admin/api_permissions/current.json'

	headers = {
		'X-Shopify-Access-Token' => access_token,
		  content_type: 'application/json',
		  accept: 'application/json'
		}

		response = RestClient.delete(revoke_url, headers)
		response.code # 200 for success
  end
end
