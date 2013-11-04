class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def validate_your_data
  end

  def send_sms
    current_user.mobile_phone_code = SecureRandom.hex(13)
    render :validate_your_data
  end

  def validate_mobile_phone
  end
  
  def validate_id_image
  end

end
