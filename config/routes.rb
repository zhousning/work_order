Rails.application.routes.draw do
  #root :to => 'controls#index'
  root :to => 'home#index'

  resources :controls, :only => [:index]
  #mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #get 'forget', to: 'admin/dashboard#index'
  #devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_for :users, :path => 'nigexiaobaobao', :skip => [ :passwords, :registrations, :confirmations], controllers: {  sessions: 'users/sessions' }
  devise_scope :user do
    #get 'forget', to: 'users/passwords#forget'
    #patch 'update_password', to: 'users/passwords#update_password'
    #post '/login_validate', to: 'users/sessions#user_validate'
    #
    #unauthenticated :user do
    #  root to: "devise/sessions#new",as: :unauthenticated_root #设定登录页为系统默认首页
    #end
    #authenticated :user do
    #  root to: "homes#index",as: :authenticated_root #设定系统登录后首页
    #end
  end

  #resources :users, :only => []  do
  #  get :center, :on => :collection
  #  get :alipay_return, :on => :collection
  #  post :alipay_notify, :on => :collection
  #  get :mobile_authc_new, :on => :member
  #  post :mobile_authc_create, :on => :member
  #  get :mobile_authc_status, :on => :member
  #end
  #resources :systems, :only => [] do
  #  get :send_confirm_code, :on => :collection
  #end


  #resources :roles

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/nishisbmsidekiq'

  #resources :properties
  #resources :nests 
  #resources :domains 
  resources :templates do
    get :produce, :on => :member
  end

  #resources :controls, :only => [:index]

  #resources :selectors

  resources :factories, :only => [] do
    resources :wxusers, :only => []  do
      get :query_list, :on => :collection
    end
    resources :work_orders do
      get :download_attachment, :on => :member
      get :download_append, :on => :member
      get :query_info, :on => :member
      get :query_record, :on => :member
      get :query_rate, :on => :member
      post :parse_excel, :on => :collection
      get :xls_download, :on => :collection
      get :query_all, :on => :collection
      get :process, :on => :collection
      get :complete, :on => :collection
      get :finish, :on => :member
    end
    resources :devices, :only => [:index]  do
      get :query_all, :on => :collection
    end
    resources :inspectors, :only => [:index] do
      get :receive, :on => :member
      get :reject, :on => :member
    end
    resources :workers, :only => [:index, :edit, :update]  do 
      get :receive, :on => :member
      get :reject, :on => :member
      get :query_info, :on => :member
      get :signlogs, :on => :member
      get :query_all, :on => :collection
      get :unvalidate, :on => :collection
      get :query_unvalidate, :on => :collection
    end
    resources :sign_logs, :only => [:index] do
      get :query_list, :on => :collection
      get :query_device, :on => :collection
    end
    resources :fct_statics, :only => [:index] do
      get :query_device, :on => :collection
      get :xls_download, :on => :collection
      get :log_detail, :on => :collection
      get :query_by_area, :on => :collection
    end

  end

  resources :wx_sign_logs, :only => [:index] do
    get :query_list, :on => :collection
    get :query_device, :on => :collection
  end

  resources :wx_devices, :only => [:index] do
    get :query_all, :on => :collection
  end

  resources :wx_workers, :only => [:index] do
    get :query_all, :on => :collection
    get :query_info, :on => :member
    get :signlogs, :on => :member
  end

  resources :grp_sign_logs, :only => [:index] do
    get :query_list, :on => :collection
    get :query_device, :on => :collection
  end

  resources :grp_inspectors, :only => [:index] do
    get :delete_inspector, :on => :member
    get :query_unuse, :on => :collection
  end

  resources :grp_devices, :only => [:index, :edit, :update, :destroy] do
    collection do
      get 'query_all'
      post 'parse_excel'
      get 'xls_download'
    end
  end

  resources :grp_workers, :only => [:index] do
    get :query_all, :on => :collection
    get :query_info, :on => :member
    get :signlogs, :on => :member
    get :destroy_worker, :on => :member
    get :supervisor, :on => :collection
    get :query_supervisor, :on => :collection
    get :send_msg, :on => :member
    post 'parse_excel', :on => :collection
    get 'xls_download', :on => :collection
  end

  resources :grp_statics, :only => [:index] do
    get :query_device, :on => :collection
    get :xls_download, :on => :collection
    get :log_detail, :on => :collection
    get :query_by_area, :on => :collection
  end

  resources :wx_users, only: [:update] do
    collection do
      post 'get_userid'
      get 'fcts'
      get 'areas'
      get 'streets'
      get 'sites'
      get 'identity'
      get 'status'
      post 'set_fct'
    end
  end
  resources :wx_tasks, only: [] do
    collection do
      get 'query_info'
      get 'query_pend'
      get 'query_rate'
      get 'query_record'
      get 'query_process'
      get 'query_all'
      get 'query_finish'
      get 'query_plan'
      get 'task_member'
      post 'task_processed'
      post 'task_transfer'
      get 'accept_task'
      get 'basic_card'
      get 'task_info'
      post 'report_create'
    end
  end
  resources :wx_resources, only: [] do
    collection do
      post 'img_upload'
    end
  end
  resources :wx_auths, only: [] do
    collection do
      post 'auth_process'
    end
  end

  #resources :systems do
  #  get :download_append, :on => :member
  #  get :query_all, :on => :collection
  #end
  resources :deploys do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :work_orders, :only => [] do
    get :assign, :on => :member
  end
  resources :order_logs do
    get :download_attachment, :on => :member
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :task_logs do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :workorder_ctgs do
    get :download_append, :on => :member
    get :query_all, :on => :collection
  end
  resources :flower

end
