class EventSeriesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id
  attribute :starred, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.starred? params[:current_user]
  end
end
