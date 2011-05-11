
# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Plugins
    module Reviews
      class NotUseRailsRootReview < RailsBestPractices::Reviews::Review
        def interesting_nodes
          [:const]
        end

        def start_const(node)
          if s(:const, :RAILS_ROOT) == node
            add_error "not use RAILS_ROOT"
          end
        end
      end
    end
  end
end
