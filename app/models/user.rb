class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy # フォローしている人取得
  has_many :followings, through: :relationships, source: :followed # 自分がフォローしている人

  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy # フォロされている人取得
  has_many :followers, through: :reverse_of_relationships, source: :follower # 自分をフォローしている人

  # ユーザをフォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # ユーザをフォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    followings.include?(user)
  end

  attachment :profile_image

  validates :name, presence: true, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 50}
end
