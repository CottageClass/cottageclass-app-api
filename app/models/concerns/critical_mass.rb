require 'active_support/concern'

module CriticalMass
  extend ActiveSupport::Concern

  included do
    def all_matches(maximum_age_difference:, distance:)
      others = User.near([latitude.to_f, longitude.to_f], distance).includes(%i[children events])

      others = others.where.not(id: id)
      others = others.to_a
      others = others.select do |o|
        other_child_ages = o.child_ages_in_months
        age_match = false
        other_child_ages.each do |other_age|
          child_ages_in_months.each do |this_age|
            next unless (this_age - other_age).abs < maximum_age_difference

            age_match = true
            break
          end
          break if age_match
        end
        age_match
      end
      others
    end

    def critical_mass?(required_total_matches:, required_matches_with_events:, maximum_age_difference:, distance:)
      all = all_matches maximum_age_difference: maximum_age_difference, distance: distance
      with_event = all.reject do |user|
        user.events.empty?
      end
      all.count > required_total_matches && with_event.count > required_matches_with_events
    end

    class << self
      def critical_count(required_total_matches, required_matches_with_events, maximum_age_difference, distance)
        matches = all.select do |u|
          cm = u.critical_mass? required_total_matches: required_total_matches,
                                required_matches_with_events: required_matches_with_events,
                                maximum_age_difference: maximum_age_difference,
                                distance: distance
          cm
        end
        matches.count
      end
    end
  end
end
