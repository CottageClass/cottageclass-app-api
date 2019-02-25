class UpdateKindInEvent < ActiveRecord::Migration[5.2]
  def change
    reversible do |direction|
      direction.up do
        Event.update_all kind: Event.kinds[:manual]
      end
    end
  end
end
