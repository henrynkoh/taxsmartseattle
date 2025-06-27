class UpdateTaxTipsAndVideos < ActiveRecord::Migration[8.0]
  def change
    # Update tax_tips table
    change_table :tax_tips do |t|
      t.change :sentiment, :float  # Change from string to float
    end

    # Update videos table
    change_table :videos do |t|
      t.change :script, :text      # Change from string to text
      t.string :title             # Add title column
    end
  end
end
