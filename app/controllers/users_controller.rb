class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def validate_your_data
  end

  def send_sms
    user = User.find current_user.id
    user.validate_mobile_phone!
    user.mobile_phone = params.require(:user).permit(:mobile_phone)[:mobile_phone]
    if user.valid?
      user.mobile_phone_code = SecureRandom.hex(5)
      user.save
      flash.now[:notice] = "SMS enviado"
    else
      flash.now[:error] = user.errors.messages.to_s
    end
    current_user.reload
    render :validate_your_data
  end

  def validate_mobile_phone
    user = User.find current_user.id
    if params[:mobile_phone_code_received] == user.mobile_phone_code
      user.mobile_phone_code = nil
      user.validation_status = 2
      user.save
      flash.now[:notice] = "Felicitaciones, haz validado tu número de teléfono correctamente."
    else
      flash.now[:error] = "El código de verificación no corresponde"
    end
    current_user.reload
    render :validate_your_data
  end
  
  def validate_id_image
    user = User.find current_user.id
    if user.update_attributes params.require(:user).permit(:id_scan)
      flash.now[:notice] = "Una vez confirmado tu ID habrás recibido la validación máxima."
    else
      flash.now[:error] = "Hubo un error al subir la imagen"
    end
    current_user.reload
    render :validate_your_data
  end

end
