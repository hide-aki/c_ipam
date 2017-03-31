require_relative './base'

class Address < Base
  include Mongoid::Document
  belongs_to :pool

  field :cidr, type: String
  field :address, type: Integer

  validate :valid_cidr
  validates :pool_id, presence: true

  before_save :populate_address

  scope :pool_id, -> (pool_id) { where(pool_id: pool_id) }

  def as_json(*args)
    res = super
    res["id"] = res.delete("_id").to_s
    res["pool_id"] = res["pool_id"].to_s
    res
  end
end
