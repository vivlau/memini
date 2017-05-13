class User < ApplicationRecord
   # Include default devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable and :omniauthable
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

   def self.find_for_google_oauth2(auth)
      data = auth.info
      if validate_email(auth)
        user = User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
        end
        user.token = auth.credentials.token
        user.refresh_token = auth.credentials.refresh_token
        user.save
        return user
      else
        return nil
      end
    end

  def self.find_or_create_from_google_oauth2(omniauth_data)
    user = User.where(provider: :google_oauth2, uid: omniauth_data["uid"]).first
    unless user
      # create user
      name = omniauth_data["info"]["name"].split
      user = User.create(provider: :google_oauth2,
                          uid: omniauth_data["uid"],
                          email: omniauth_data["info"]["email"],
                          first_name: omniauth_data["info"]["first_name"],
                          last_name: omniauth_data["info"]["last_name"],
                          consumer_token: omniauth_data["credentials"]["token"],
                          omniauth_raw_data: omniauth_data
                          )
    end
    user
  end

end
