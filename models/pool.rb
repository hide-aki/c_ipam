require_relative './base'

class Pool < Base
	include Mongoid::Document
	belongs_to :block
	has_many :addresses, :dependent => :destroy

	field :cidr, type: String
	field :start_address, type: Integer
	field :end_address, type: Integer

	validate :valid_cidr
	validates :block_id, presence: true
  validates_uniqueness_of :cidr, :scope => :block_id

	before_save :populate_start_and_end

  scope :block_id, -> (block_id) { where(block_id: block_id) }

	def get_next_free_address
		last_address = self.addresses.asc(:address).last
		cidr = NetAddr::CIDR.create(last_address["address"] + 1).to_s if last_address
		cidr = NetAddr::CIDR.create(self["start_address"] + 1).to_s if !cidr
		return self.addresses.create(cidr: cidr)
	end

	def as_json(*args)
		res = super
		res["id"] = res.delete("_id").to_s
    res["block_id"] = res["block_id"].to_s
		res
	end
end
