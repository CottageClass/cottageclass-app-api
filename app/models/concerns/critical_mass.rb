require 'active_support/concern'

module CriticalMass
  extend ActiveSupport::Concern

  included do
    def all_matches
      others = User.near([latitude.to_f, longitude.to_f], 0.5)
      others = others.where.not(id: id)
      others = others.to_a
      others = others.select do |o|
        other_child_ages = o.child_ages_in_months
        age_match = false
        other_child_ages.each do |other_age|
          child_ages_in_months.each do |this_age|
            if (this_age - other_age).abs < 36
              age_match = true
              break
            end
          end
          break if age_match
        end
        age_match
      end
      others
    end

    def critical_mass?
      all = all_matches
      with_event = all.reject do |user|
        user.events.empty?
      end
      all.count > 100 && with_event.count > 30
    end
  end
end
