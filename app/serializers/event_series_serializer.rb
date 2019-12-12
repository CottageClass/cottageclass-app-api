class EventSeriesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :start_date, :child_age_minimum, :child_age_maximum, :id

  attribute(:starts_at) { |object| object.starts_at.to_s :time }
  attribute(:ends_at) { |object| object.ends_at.to_s :time }
  has_many :events

  attribute :starred, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.starred? params[:current_user]
  end
end
