class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def validate_your_data
  end

  def send_sms
    current_user.mobile_phone = params[:user][:mobile_phone]
    if current_user.valid?
      current_user.mobile_phone_code = SecureRandom.hex(5)
      current_user.save
      flash.now[:notice] = "SMS enviado"
    else
      flash.now[:error] = current_user.errors
    end
    render :validate_your_data
  end

  def validate_mobile_phone
    if params[:mobile_phone_code_received] == current_user.mobile_phone_code
      current_user.mobile_phone_code = nil
      current_user.validation_status = 2
      current_user.save
      flash.now[:notice] = "Felicitaciones, haz validado tu número de teléfono correctamente."
    else
      flash.now[:error] = "El código de verificación no corresponde"
    end
    render :validate_your_data
  end
  
  def validate_id_image
    if current_user.update_attributes params.require(:user).permit(:id_scan)
      flash.now[:notice] = "Una vez confirmado tu ID habrás recibido la validación máxima."
    else
      flash.now[:error] = "Hubo un error al subir la imagen"
    end
    render :validate_your_data
  end

end
