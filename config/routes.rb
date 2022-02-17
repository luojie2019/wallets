Rails.application.routes.draw do

  resources :balances do
    collection do
    	get :recharge
      post :recharge
    end
  end

  resources :payments do
    collection do
      get "pay_trade/:trade_no", to: "payments#pay_trade"
      get "notification/:gateway_type/:trade_no", to: "payments#notification"
      post "notification/:gateway_type/:trade_no", to: "payments#notification"
    end
  end

end
