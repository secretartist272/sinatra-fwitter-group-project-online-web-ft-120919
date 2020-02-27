class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def slug
    str = self.username.split(" ")
    str.map{|word| word.downcase}.join("-")
  end

  def self.find_by_slug(slug)
    self.all.find{ |user_slug| user_slug.slug == slug }
  end
end
