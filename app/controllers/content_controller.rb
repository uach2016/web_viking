class ContentController < ApplicationController
	require 'rest-client'
	require 'json'

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

  def create_domain
  	params = {product: product, domain: domain, name: current_user.name, email: current_user.email, promo: current_user.id}

    response = RestClient.post 'https://seoapp.webviking.eu/api/accounts', params, :'X-Auth-Token' => "1bb6343e8153b342f346b9559938cdb0d927a8ed"
    puts response.inspect

    @domain.market_goo_guid = response.body
    @domain.market_goo_guid.save
  end
end
