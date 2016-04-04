# This migration comes from monologue_markdown (originally 20130913004609)
class MergeMarkdownRevisionsIntoPosts < ActiveRecord::Migration

  class Monologue::Post < ActiveRecord::Base
  end

  def up
    Monologue::Post.reset_column_information
    add_column :monologue_posts, :is_markdown, :boolean

    Monologue::Post.reset_column_information

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
