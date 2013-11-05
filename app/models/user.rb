class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  #attr_accessible :provider, :uid, :name
  validates :mobile_phone, :numericality => { :only_integer => true, :greater_than => 100000 }, :if => :validate_mobile_phone
  validates :last_name, :presence => true, :on => :create

  # FIX-ME we could use state machine
  VALIDATION_STATUS = { '0' => 'none', '1' => 'basic', '2' => 'advanced', '3' => 'maximum'  }

  has_attached_file :id_scan

  after_save :set_validation_status

  def validate_mobile_phone!
    @validate_mobile_phone = true
  end

  def validate_mobile_phone
    @validate_mobile_phone
  end

  def set_validation_status
    if self.confirmed? and validation_status == 0
      update_attribute :validation_status , 1
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    logger.info auth.inspect
    if user
      user.name = auth.extra.raw_info.first_name
      user.last_name = auth.extra.raw_info.last_name
      user.email = auth.info.email
      user.birth_date = auth.extra.raw_info.birthday
      user.mobile_phone = nil
      user.facebook_photo_url = auth.info.image
      user.address = auth.extra.raw_info.location.name
      user.save
    else
      user = User.new(name: auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        birth_date: auth.extra.raw_info.birthday,
        mobile_phone: nil,
        facebook_photo_url: auth.info.image,
        address: auth.extra.raw_info.location.name,
        password:Devise.friendly_token[0,20])
      user.skip_confirmation!
      user.save
    end
    if not user.mobile_phone.nil? and user.validation_status < 2
      user.update_attribute :validation_status, 2
    end
    user
  end


end
