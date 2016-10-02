class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception
  layout :layout_by_resource

  protected
  after_filter :store_location
  $courier = ["Aeropos","Airborne Express","Amazon Logistics","AP","China Post / International Mail","DHL / Airborne","FedEx","FedEx Freight","Lasership","Motor Freight - South Eastern","Other","Pitney Bowes","PriceSmart","SpeedBox","StratAir","Streamlite","UPS","UPS Mail Innovations","UPS Next Day","USPS","Walk-In","WN Direct","Otro"]
  $shop = ["AMAZON","EBAY","AEROPOSTALE","AMERICAN EAGLE","OTRA"]


  def layout_by_resource
   if devise_controller? && resource_name == :admin
      "admins"
    else
      if devise_controller? && resource_name == :user
       "devise"
      else
        "application"
      end

    end
  end

  def store_location
    if devise_controller? && resource_name == :admin
        return unless request.get?
        if (request.path != "/users/sign_in" &&
            request.path != "/users/sign_up" &&
            request.path != "/users/password/new" &&
            request.path != "/users/password/edit" &&
            request.path != "/users/confirmation" &&
            request.path != "/users/edit" &&
            request.path != "/users/sign_out" &&
            !request.xhr?)
            store_location_for(:user, request.fullpath)
        end
    else
      if devise_controller? && resource_name == :user
          return unless request.get?
          if (request.path != "/admins/sign_in" &&
              request.path != "/admins/sign_up" &&
              request.path != "/admins/password/new" &&
              request.path != "/admins/password/edit" &&
              request.path != "/admins/confirmation" &&
              request.path != "/admins/edit" &&
              request.path != "/admins/sign_out" &&
              !request.xhr?)
              store_location_for(:admin, request.fullpath)
            end
          end 
      end

  end

  def after_sign_in_path_for(resource)
    if authenticate_admin!
      session[:previous_url] || admin_index_path
    else
      session[:previous_url] || box_index_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def configure_permitted_parameters
    added_attrs = [:email,:name,:lastname,:dni, :password, :password_confirmation, :remember_me,:address,:phone_mobile,:phone_home,:phone_work,:country,:birth_date,:account_number,:humanizer_answer,:humanizer_question_id]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end



end
