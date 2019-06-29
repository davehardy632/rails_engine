Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get '/find', to: "find#show"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: "find#show"
        get '/random', to: "random#show"
        get '/find_all', to: "find#index"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :customers do
          get "/:id/invoices", to: "invoice#index"
          get "/:id/transactions", to: "transaction#index"
          get "/find_all", to: "find#index"
      end
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :merchants do
          get "/:id/items", to: "items#index"
          get "/:id/invoices", to: "invoice#index"
          get "/:id/favorite_customer", to: "customer#show"
          get "/:id/revenue", to: "revenue#show"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :invoices do
          get "/:id/transactions", to: "transactions#show"
          get "/:id/items", to: "items#show"
          get "/:id/invoice_items", to: "invoice_items#show"
          get "/:id/customer", to: "customer#show"
          get "/:id/merchant", to: "merchant#show"
      end
    end
  end
  namespace :api do
    namespace :v1 do
      namespace :invoice_items do
        get "/:id/item", to: "item#show"
        get "/:id/invoice", to: "invoice#show"
        get "/find", to: "search#show"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :items do
          get "/:id/invoice_items", to: "invoice_items#show"
          get "/:id/merchant", to: "merchant#show"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :transactions do
          get "/:id/invoice", to: "invoice#show"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :invoices, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :transactions, only: [:index, :show]
    end
  end
end
