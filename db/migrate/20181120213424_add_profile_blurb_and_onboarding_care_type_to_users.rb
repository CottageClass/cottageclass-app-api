class AddProfileBlurbAndOnboardingCareTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile_blurb, :text
    add_column :users, :onboarding_care_type, :string
  end
end
