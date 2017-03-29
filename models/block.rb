require_relative './base'

class Block < Base
  include Mongoid::Document
	has_many :pools, :dependent => :destroy

	field :cidr, type: String
	field :network_view, type: String
	field :start_address, type: Integer
	field :end_address, type: Integer

  validate :valid_cidr
	validates :network_view, presence: true
	validates_uniqueness_of :cidr, :scope => :network_view

  before_save :populate_start_and_end
	
	scope :network_view, -> (network_view) { where(network_view: network_view) }

	def get_next_free_pool(block_size)
		last_pool = self.pools.asc(:end_address).last
		cidr = NetAddr::CIDR.create(last_pool["end_address"] + 1).resize(block_size).to_s if last_pool
		cidr = NetAddr::CIDR.create(self["start_address"]).resize(block_size).to_s if !cidr
		return self.pools.create(cidr: cidr)
	end

	def as_json(*args)
		res = super
		res["id"] = res.delete("_id").to_s
		res
	end
end