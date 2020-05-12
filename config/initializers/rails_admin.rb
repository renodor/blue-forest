RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
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

  config.included_models = ["Product", "ProductVariation", "User", "Order", "Category", "FakeUser", "Address"]

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
  end

  config.model 'Product' do
    list do
      field :id
      field :name
      field :published
      field :categories
      field :product_variations
      field :main_photo
      field :description
      field :created_at
      field :updated_at
    end
  end

  config.model 'Order' do
    list do
      field :id
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
      field :total
      field :product_variations
      field :shipping
      field :itbms
      field :sub_total
      field :fake_user
      field :user
      field :created_at
    end
  end

  config.authorize_with do
    unless current_user.admin?
      flash[:alert] = 'Sorry, no admin access for you.'
      redirect_to main_app.root_path
    end
  end
end
