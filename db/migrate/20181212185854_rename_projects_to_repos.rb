class RenameProjectsToRepos < ActiveRecord::Migration[5.2]
  def change
    rename_table :projects, :repos
  end
end
