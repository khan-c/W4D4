# == Schema Information
#
# Table name: sessions
#
#  id            :integer          not null, primary key
#  session_token :string           not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Session < ApplicationRecord
  validates :session_token, :user_id, presence: true
  validates :session_token, uniqueness: true

  belongs_to :user

  def self.new_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end
end
