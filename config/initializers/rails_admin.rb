RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user

    # Set default locale
    I18n.locale = :en
  end
  config.current_user_method(&:current_user)
  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = ["Product", "ProductVariation", "ProductPhoto", "User", "Order", "Category", "FakeUser", "Address"]

  config.navigation_static_links = {
  'CREATE PRODUCT' => '/product_creation'
  }

  config.model 'Product' do
    weight 0
    list do
      field :id
      field :order
      field :name
      field :published
      field :categories
      field :product_variations do inverse_of :products end
      field :short_description
      field :long_description
      field :created_at
      field :updated_at
    end

    create do
      configure :product_variations do
        hide
      end
    end

    edit do
      configure :product_variations do
        inline_add false
      end
    end
  end

  config.model 'ProductVariation' do
    parent Product
    list do
      field :id
      field :name
      field :published
      field :price
      field :discount_price
      field :quantity
      field :product
      field :size
      field :color
      field :created_at
      field :updated_at
    end

    create do
      configure :name do
        hide
      end
    end

    edit do
      configure :name do
        hide
      end
    end
  end

  config.model 'Category' do
    weight 1
  end

  config.model 'Order' do
    weight 3
    list do
      field :id
      field :status
      field :total
      field :product_variations
      field :shipping
      field :itbms
      field :sub_total
      field :fake_user
      field :user
      field :created_at
    end

    show do
      field :id
      field :status
      field :total
      field :product_variations
      field :shipping
      field :itbms
      field :sub_total
      field :fake_user
      field :user
      field :created_at
    end

    edit do
      configure :status , :enum do
        enum do
          ['confirmed', 'pick_pack', 'shipping', 'delivered']
        end
      end
    end
  end

  config.model 'User' do
    weight 4
    exclude_fields :reset_password_sent_at, :remember_created_at

    create do
      configure :orders do
        hide
      end
    end

    edit do
      configure :orders do
        hide
      end
    end
  end

  config.model 'FakeUser' do
    weight 5

    create do
      configure :orders do
        hide
      end
    end

    edit do
      configure :orders do
        hide
      end
    end
  end

  config.model 'Address' do
    visible false

    show do
      configure :latitude do hide end
      configure :longitude do hide end
      configure :google_maps_link do show end
    end

    edit do
      configure :latitude do hide end
      configure :longitude do hide end
      configure :user do
        inline_add false
        inline_edit false
      end
      configure :fake_user do
        inline_add false
        inline_edit false
      end
    end
  end

  config.authorize_with do
    unless current_user.admin?
      flash[:alert] = 'Sorry, no admin access for you.'
      redirect_to main_app.root_path
    end
  end
end
