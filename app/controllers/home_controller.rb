class HomeController < ShopifyApp::AuthenticatedController
	require 'rest-client'
	require 'json'

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
  end

  def create 
  	# Check if shop not exist in dbase
		if !Shop.exists?(:shopify_id => @shop.id)
	  # Create it
	 	@newshop = Shop.create({domain: domain, name: current_user.name, email: current_user.email, promo: current_user.id})

    response = RestClient.post 'http://webviking.stage.mktgoo.net//api/accounts', params, :'X-Auth-Token' => "1bb6343e8153b342f346b9559938cdb0d927a8ed"
    puts response.inspect

    metafield = ShopifyAPI::Metafield.new(:resource => 'products', :resource_id => product.last.id, :namespace => 'web_viking', :key => 'id', :value_type => 'string', :value => response.body)
		metafield.namespace = metafield.namespace.parameterize
		metafield.save
		end
	end

	def delete
		shop = ShopifyAPI::Shop.current.domain
		access_token = 'secret'
		revoke_url   = 'https://'+shop+'/admin/api_permissions/current.json'

		headers = {
		  'X-Shopify-Access-Token' => access_token,
		  content_type: 'application/json',
		  accept: 'application/json'
		}

		if response = RestClient.delete(revoke_url, headers)
			 response.code # 200 for success
			 flash[:alert] = 'App deleted.'
       redirect_to :back
    else
      flash[:alert] = 'Sorry, something went wrong'
      redirect_to :back
    end
  end
end

 
