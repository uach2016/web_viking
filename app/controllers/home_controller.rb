class HomeController < ShopifyApp::AuthenticatedController
	require 'rest-client'
	require 'json'

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @shop = ShopifyAPI::Shop.current
  end

  def create 
  	# Check if shop not exist in dbase
		if !Shop.exists?(:shopify_id => @shop.id)
	  # Create it
	 	@newshop = Shop.create({domain: @shop.domain, name: current_user.name, email: @shop.email, promo: ''})

    #we need to post to this address, that will give us a response which is the MARKETGOO ID
    response = RestClient.post 'http://webviking.stage.mktgoo.net/api/accounts', params, :'X-Auth-Token' => "1bb6343e8153b342f346b9559938cdb0d927a8ed"
   
    # You will need to create this field in the database on your Shop model, this will then store the MarketGoo Id which we will need shortly.
    @newshop.market_goo_id = response.body

    #Save the shiz
    @newshop.save
    metafield = ShopifyAPI::Metafield.new(:resource => 'products', :resource_id => product.last.id, :namespace => 'web_viking', :key => 'id', :value_type => 'string', :value => response.body)
		metafield.namespace = metafield.namespace.parameterize
		metafield.save
		end
	end

	def delete
		shop_domain = @shop.domain
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

  def login_link
   @shop = Shop.new
   RestClient::Request.execute(method: :get, url: "webviking.stage.mktgoo.net/api/login/#{@shop.market_goo_guid}", :headers => {"X-Auth-Token"=> "1bb6343e8153b342f346b9559938cdb0d927a8ed"}) do |response, request, result, &block|
     if [301, 302, 307].include? response.code
       redirected_url = response.headers[:location]
       redirect_to redirected_url
     else
       response.return!(request, result, &block)
     end
   end
 end

end

