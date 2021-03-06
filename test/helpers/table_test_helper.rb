module TableTestHelper
  
  def create_users_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :users do |t|
          t.string   :email
          t.string   :hashed_password
          t.string   :salt
        end
      end
    end
  end
  
  def drop_all_tables
    ActiveRecord::Base.connection.tables.each do |table|
      drop_table(table)
    end
  end
  
  def drop_table(table)
    ActiveRecord::Base.connection.drop_table(table)
  end
  
end