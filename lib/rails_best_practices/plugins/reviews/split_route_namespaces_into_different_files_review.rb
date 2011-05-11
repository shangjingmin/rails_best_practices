
# encoding: utf-8
require 'rails_best_practices/reviews/review'

module RailsBestPractices
  module Plugins
    module Reviews
      class SplitRouteNamespacesIntoDifferentFilesReview < RailsBestPractices::Reviews::Review
        def debug
        end
        def interesting_nodes
          [:call]
        end

        def interesting_files
          ROUTE_FILE
        end

        def start_call(node)
          add_error "split route namespaces into different files" if (s(:lvar, :map)==node.subject && :namespace==node.message && :call==node.node_type)
        end
      end
    end
  end
end
