Rails.application.routes.draw do

  resources :balances do
    collection do
    	get :recharge
      post :recharge
      get :transfer
      post :transfer
      get :recharge_list
    end
  end

  resources :payments do
    collection do
      get "pay_trade/:trade_no", to: "payments#pay_trade"
      get "pay_trade_by_wallets/:trade_no", to: "payments#pay_trade_by_wallets"
      get "notification/:gateway_type/:trade_no", to: "payments#notification"
      post "notification/:gateway_type/:trade_no", to: "payments#notification"
    end
  end

end
