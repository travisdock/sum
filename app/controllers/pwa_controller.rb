class PwaController < ApplicationController
  allow_unauthenticated_access

  def manifest
    render json: render_to_string(template: 'pwa/manifest', formats: :json),
           content_type: 'application/manifest+json'
  end

  def service_worker
    render file: Rails.public_path.join('service-worker.js'),
           content_type: 'application/javascript',
           layout: false
  end
end
