# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  session_id      :integer          not null
#

class User < ApplicationRecord
  validates :username, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :cats
  has_many :rental_requests,
    class_name: :CatRentalRequest,
    primary_key: :id,
    foreign_key: :user_id
  has_many :sessions

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.valid_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def ensure_session_token
    # self.session_token ||= Session.new_token
    if self.sessions.empty?
      Session.create(user_id: self.id, session_token: Session.new_token)
    end
  end

  def reset_session_token!
    Session.find(self.session_id).reset_session_token!
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
