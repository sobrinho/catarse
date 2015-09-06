class GrantOnRewardDetails < ActiveRecord::Migration
  def up
    execute <<-SQL
      grant select on "1".reward_details to anonymous;
      grant select on "1".reward_details to web_user;
    SQL
  end

  def down
    execute <<-SQL
      revoke select on "1".reward_details from anonymous;
      revoke select on "1".reward_details from web_user;
    SQL
  end
end
