class AddRedisEndpointToAccount < ActiveRecord::Migration
  def change
    add_reference :accounts, :redis_endpoint, index: true
  end
end
