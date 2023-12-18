module OmniAuth
  module OpenIDConnect
    class Client < ::OpenIDConnect::Client
      def access_token!(*args)
        headers, params, http_client, options = authenticated_context_from(*args)
        params[:scope] = Array(options.delete(:scope)).join(' ') if options[:scope].present?
        params.merge! @grant.as_json
        params.merge! options
        handle_response do
          http_client.get(
            absolute_uri_for(token_endpoint),
            Util.compact_hash(params),
            headers
          ) do |req|
            yield req if block_given?
          end
        end
      end
    end
  end
end
