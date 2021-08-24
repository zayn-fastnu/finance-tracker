class CreateUserStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_stocks do |t|
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      t.references :stock, null: false, foreign_key: {on_delete: :cascade}
      #foreign_key: true, :on_delete => :cascade

      t.timestamps
    end
  end
end
