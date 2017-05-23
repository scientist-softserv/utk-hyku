class AddRedisEndpointToAccount < ActiveRecord::Migration[4.2]
  def change
    add_reference :accounts, :redis_endpoint, index: true
  end
end
