module API
  module Support
    module Helpers
      def set(params)
        declared(params, include_parent_namespaces: false,
                         include_missing: false)
      end

      def find(collection, quexry, code = nil)
        collection.find_by(query).tap do |m|
          unless m
            class_name = collection.respond_to?(:model) ? collection.model.name : collection
            not_found!(*["#{class_name} with query '#{query}' was not found", code].compact)
          end
        end
      end

      def paginate(query, per_page: params[:per_page], page: params[:page])
        total_rows = query.unscope(:select).count

        present :total_rows, total_rows
        present :total_pages, (total_rows / per_page.to_f).ceil

        query.limit(per_page).offset((page - 1) * per_page)
      end

      def sort(query, sort_by: params[:sort_by], sort_direction: params[:sort_direction])
        # not using hash syntax because Rails will prefix the table name of the collection
        # model (users.last_name), and that could be undesired behavior (eg. joins)
        query.order("#{sort_by} #{sort_direction}")
      end
    end
  end
end
