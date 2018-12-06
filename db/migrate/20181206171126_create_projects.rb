class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :url
      t.string :type

      t.timestamps
    end
  end
end
