module Api
  class DocsController < ActionController::API
    def show
      render plain: Rails.root.join('docs', 'api.md').read, content_type: 'text/markdown'
    end
  end
end
